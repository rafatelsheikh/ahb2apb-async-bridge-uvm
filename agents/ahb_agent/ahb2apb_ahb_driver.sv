`ifndef AHB2APB_AHB_DRIVER_SV
    `define AHB2APB_AHB_DRIVER_SV

    class ahb2apb_ahb_driver extends uvm_driver#(.REQ(ahb2apb_ahb_item_drv)) implements ahb2apb_reset_handler;

        // configuration object
        ahb2apb_ahb_agent_config cfg;
        
        // previous driving item to allow phase overlap
        protected ahb2apb_ahb_item_drv prev_item; 

         // point to the driving process
        protected process process_drive_transactions;
        
        `uvm_component_utils(ahb2apb_ahb_driver)

        function new(string name = "AHB_driver", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase); 
            super.build_phase(phase);
            
            if (!uvm_config_db#(ahb2apb_ahb_agent_config)::get(this, "", "CFG", cfg)) begin
                `uvm_fatal("CFG_DB_GET_FAILED", "Driver failed getting the cfguration object")
            end
        endfunction

        virtual task run_phase(uvm_phase phase);
            forever begin
                fork
                    begin
                        wait_reset_end();
                        drive_transactions();
                        disable fork;        
                    end
                join
            end
        endtask

        protected virtual task drive_transactions();
            ahb2apb_ahb_vif vif = cfg.get_vif();
            ahb2apb_ahb_item_drv item;
            fork
                begin
                    // getting process of driving
                    process_drive_transactions = process::self();
                    
                    prev_item = null;

                    forever begin
                        
                        seq_item_port.try_next_item(item);

                        if (item == null) begin
                            // to ensure idel state as the no more items is coming    
                            vif.HTRANS <= '0;

                            data_phase(prev_item);
                            prev_item = null;
                        end 
                        else begin
                            drive_transaction(item);

                            `uvm_info("ITEM_END", $sformatf("Driving: %0s", item.convert2string()), UVM_LOW)

                            seq_item_port.item_done();    
                        end       
                    end
                end
            join
        endtask



        // driving logic
        protected virtual task drive_transaction(ahb2apb_ahb_item_drv item);
            ahb2apb_ahb_vif vif = cfg.get_vif();

            `uvm_info("ITEM_START", $sformatf("Driving: %0s", item.convert2string()), UVM_LOW)
            
            
            // running address phase and data phase in parrallel for overlappings
            fork
                data_phase(prev_item);
                addr_phase(item);
            join
            // save item for its data phase
            prev_item = item;
            
            
        endtask

        // address phase task
        protected virtual task addr_phase(ahb2apb_ahb_item_drv item);
            ahb2apb_ahb_vif vif = cfg.get_vif();
            
            vif.HSEL   <= item.hsel;
            vif.HWRITE <= item.hwrite;
            vif.HADDR  <= item.haddr;
            vif.HTRANS <= item.htrans;
            vif.HSIZE  <= item.hsize;
            vif.HPROT  <= item.hprot;
            @(posedge vif.HCLK);
            
        endtask

        // data phase task
        protected virtual task data_phase(ahb2apb_ahb_item_drv item);
            ahb2apb_ahb_vif vif = cfg.get_vif();

            if(item != null && item.hwrite == AHB_WRITE) begin
                vif.HWDATA <= item.hwdata;
            end
            @(posedge vif.HCLK);

            // freez data phase untill hreadyout is high
            while (vif.HREADYOUT != 1) begin
                @(posedge vif.HCLK);
            end
        endtask

        // task for assignining the defualt values 
        protected virtual task set_defualt_values();
            ahb2apb_ahb_vif vif = cfg.get_vif();

            vif.HSEL   <= '0;
            vif.HADDR  <= '0;
            vif.HTRANS <= '0;
            vif.HSIZE  <= '0;
            vif.HPROT  <= '0;
            vif.HWRITE <= '0;        
            vif.HWDATA <= '0;   
        endtask


        // reset handle         
        protected virtual task wait_reset_end();
            cfg.wait_reset_end();
        endtask

        virtual function void handle_reset (uvm_phase phase);
            ahb2apb_ahb_vif vif = cfg.get_vif();

            if (process_drive_transactions != null)begin
                process_drive_transactions.kill();
                process_drive_transactions = null;
            end

            set_defualt_values();
        endfunction
        
    endclass 

`endif