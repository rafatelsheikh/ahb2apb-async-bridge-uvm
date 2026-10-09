// ahb2apb_apb_sequencer.sv

`ifndef AHB2APB_APB_SEQUENCER_SV
    `define AHB2APB_APB_SEQUENCER_SV

    class ahb2apb_apb_sequencer extends uvm_sequencer #(ahb2apb_apb_item_drv) implements ahb2apb_reset_handler;

        `uvm_component_utils(ahb2apb_apb_sequencer)

        // Requests received from the monitor
        uvm_tlm_analysis_fifo #(ahb2apb_apb_item_mon) request_fifo;
        // APB Memory
        ahb2apb_apb_mem memory;

        // Receives monitor transactions
        uvm_analysis_export #(ahb2apb_apb_item_mon) request_export;

        function new(string name = "ahb2apb_apb_sequencer", uvm_component parent = null);
            super.new(name, parent);
            request_export = new("request_export", this);
            request_fifo = new("request_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            request_export.connect(request_fifo.analysis_export);
        endfunction

        virtual function void handle_reset(uvm_phase phase);
            int objections_count;

            stop_sequences();

            objections_count = uvm_test_done.get_objection_count(this);

            if(objections_count > 0) begin
                uvm_test_done.drop_objection(this, $sformatf("Dropping %od objections at reset", objections_count), objections_count);
            end
            start_phase_sequence(phase);
        endfunction

    endclass

`endif