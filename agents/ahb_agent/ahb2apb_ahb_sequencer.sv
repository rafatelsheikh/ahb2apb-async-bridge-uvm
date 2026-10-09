`ifndef AHB2APB_AHB_SEQUENCER_SV
    `define AHB2APB_AHB_SEQUENCER_SV

    class ahb2apb_ahb_sequencer extends uvm_sequencer#(.REQ(ahb2apb_ahb_item_drv)) implements ahb2apb_reset_handler;
        
        `uvm_component_utils(ahb2apb_ahb_sequencer)
        
        function new(string name = "ahb_sequencer", uvm_component parent);
            super.new(name, parent);            
        endfunction 

        virtual function void handle_reset(uvm_phase phase);
            int objections_count;
            // stop all sequences 
            stop_sequences();

            objections_count = uvm_test_done.get_objection_count(this);
 
            if (objections_count > 0) begin
                uvm_test_done.drop_objection(this, $sformatf("Dropping %0d objections at reset", objections_count), objections_count);                
            end

            start_phase_sequence(phase);
        endfunction

    endclass

`endif