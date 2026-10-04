`ifndef AHB2APB_AHB_SEQUENCER_SV
    `define AHB2APB_AHB_SEQUENCER_SV

    class ahb2apb_ahb_sequencer extends uvm_sequencer#(.REQ(ahb2apb_ahb_item_drv));
        
        `uvm_component_utils(ahb2apb_ahb_sequencer)
        
        function new(string name = "ahb_sequencer", uvm_component parent);
            super.new(name, parent);            
        endfunction 

    endclass

`endif