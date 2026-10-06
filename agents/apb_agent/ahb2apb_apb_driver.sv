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
            super.run_phase(phase);
            forever begin
                stim_seq_item = ahb2apb_apb_item_drv::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);
                
                repeat (stim_seq_item.prv_item_delay) @(posedge vif.PCLK); //waiting random time

                //drive the signals to the interface
                vif.PREADY <= stim_seq_item.PREADY;
                vif.PSLVERR <= stim_seq_item.PSLVERR;
                vif.PRDATA <= stim_seq_item.PRDATA;

                @(posedge vif.PCLK); // wait 1 clock cycle for the slave to respond then go to idle state
                idle_state(); 

                repeat (stim_seq_item.aftr_item_delay) @(posedge vif.PCLK); //waiting random time
                seq_item_port.item_done();
                `uvm_info("abp_driver_run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask

        function void idle_state();
            vif.PREADY <= 1'b0;
            vif.PSLVERR <= 1'b0;
            vif.PDATA <= '0;
        endfunction

    endclass

`endif
