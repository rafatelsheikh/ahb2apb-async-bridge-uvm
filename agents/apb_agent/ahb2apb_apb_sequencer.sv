// ahb2apb_apb_sequencer.sv

`ifndef AHB2APB_APB_SEQUENCER_SV
    `define AHB2APB_APB_SEQUENCER_SV

    class ahb2apb_apb_sequencer extends uvm_sequencer #(ahb2apb_apb_item_drv);

        `uvm_component_utils(ahb2apb_apb_sequencer)

        // Requests received from the monitor
        uvm_tlm_analysis_fifo #(ahb2apb_apb_item_mon) request_fifo;

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

    endclass

`endif