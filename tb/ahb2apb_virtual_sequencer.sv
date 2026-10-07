`ifndef AHB2APB_VIRTUAL_SEQUENCER_SV
    `define AHB2APB_VIRTUAL_SEQUENCER_SV

    class ahb2apb_virtual_sequencer extends uvm_sequencer;
        `uvm_component_utils(ahb2apb_virtual_sequencer)

        // dfining sequencers handles
        ahb2apb_ahb_sequencer ahb_sequencer;
        ahb2apb_apb_sequencer apb_sequencer;

        // constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass

`endif