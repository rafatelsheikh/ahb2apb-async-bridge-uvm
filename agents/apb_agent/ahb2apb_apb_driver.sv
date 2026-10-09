`ifndef AHB2APB_APB_DRIVER_SV
    `define AHB2APB_APB_DRIVER_SV

    class ahb2apb_apb_driver extends uvm_driver  #(ahb2apb_apb_item_drv) implements ahb2apb_reset_handler;   ;
        `uvm_component_utils(ahb2apb_apb_driver)

        virtual ahb2apb_apb_if vif;
        ahb2apb_apb_item_drv stim_seq_item;
        ahb2apb_apb_config_obj cfg;

        //process of the driver_response task to handle the reset
        protected process process_driver_response;

        function new(string name = "Driver",uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
        forever begin
            fork begin
                wait_reset_end();
                drive_response(stim_seq_item);

                disable fork; // to ensure that if there any other processes running in driver_response are killed when reset is asserted
            end
            join

        end
        endtask


        task drive_response(ahb2apb_apb_item_drv item);
            // Initial Values: PREADY=0, PSLVERR=0, PRDATA=0
            idle_state();
            fork begin
                process_driver_response = process::self();
                forever begin 
                    seq_item_port.get_next_item(item);
                    `uvm_info("ITEM_START", item.convert2string_stimulus(), UVM_HIGH)

                    // wait states: PREADY stays LOW (already LOW from idle_state), PSLVERR LOW
                    repeat (item.wait_states) @(posedge vif.PCLK);

                    //Drive the response
                    vif.PREADY  <= 1'b1; //end of transaction
                    vif.PSLVERR <= item.pslverr;
                    vif.PRDATA  <= item.prdata;

                    // hold for exactly one edge, that is the edge where the bridge samples PREADY = 1
                    @(posedge vif.PCLK);

                    idle_state();
                    repeat (item.aftr_item_delay) @(posedge vif.PCLK); // wait random time
                    seq_item_port.item_done();
                    `uvm_info("ITEM_END", item.convert2string_stimulus(), UVM_HIGH)
                end
            end
            join
        endtask

        //Function to handle the reset
        virtual function void handle_reset(uvm_phase phase);
            if(process_driver_response != null) begin
                process_driver_response.kill();
                process_driver_response = null;
            end
            
            if (stim_seq_item != null) begin
                seq_item_port.item_done();
                stim_seq_item = null;
            end

            idle_state();
        endfunction

        //Default values for the APB signals
        function void idle_state();
            vif.PREADY  <= 1'b0;
            vif.PSLVERR <= 1'b0;
            vif.PRDATA  <= '0;
        endfunction

        //Task for waiting the reset to end
        protected virtual task wait_reset_end();
            cfg.wait_reset_end();
        endtask

    endclass

`endif