`ifndef AHB2APB_APB_DRIVER_SV
    `define AHB2APB_APB_DRIVER_SV

    class ahb2apb_apb_driver extends uvm_driver  #(ahb2apb_apb_item_drv);
        `uvm_component_utils(ahb2apb_apb_driver)

        virtual ahb2apb_apb_if vif;
        ahb2apb_apb_item_drv stim_seq_item;

        function new(string name = "Driver",uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            // Initial Values: PREADY=0, PSLVERR=0, PRDATA=0
            idle_state();
            forever begin
                seq_item_port.get_next_item(stim_seq_item);
                `uvm_info("ITEM_START", stim_seq_item.convert2string_stimulus(), UVM_MEDIUM)

                drive_response(stim_seq_item);

                idle_state();
                repeat (stim_seq_item.aftr_item_delay) @(posedge vif.PCLK); // wait random time
                seq_item_port.item_done();
                `uvm_info("ITEM_END", stim_seq_item.convert2string_stimulus(), UVM_MEDIUM)
            end
        endtask


        task drive_response(ahb2apb_apb_item_drv item);
            // wait states: PREADY stays LOW (already LOW from idle_state), PSLVERR LOW
            repeat (item.wait_states) @(posedge vif.PCLK);

            
            vif.PREADY  <= 1'b1; //end of transaction
            vif.PSLVERR <= item.pslverr;
            vif.PRDATA  <= item.prdata;

            // hold for exactly one edge, that is the edge where the bridge samples PREADY = 1
            @(posedge vif.PCLK);
        endtask

        function void idle_state();
            vif.PREADY  <= 1'b0;
            vif.PSLVERR <= 1'b0;
            vif.PRDATA  <= '0;
        endfunction

    endclass

`endif