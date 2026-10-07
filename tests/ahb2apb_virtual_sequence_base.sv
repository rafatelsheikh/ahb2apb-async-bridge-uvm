`ifndef AHB2APB_VIRTUAL_SEQUENCE_BASE_SV
    `define AHB2APB_VIRTUAL_SEQUENCE_BASE_SV

    class ahb2apb_virtual_sequence_base extends uvm_sequence;
        `uvm_object_utils(ahb2apb_virtual_sequence_base)
        `uvm_declare_p_sequencer(ahb2apb_virtual_sequencer) //vseqr class name

        // sequencers handles
        ahb2apb_ahb_sequencer ahb_seqr;
        ahb2apb_apb_sequencer apb_seqr; 

        // constructor
        function new(string name = "ahb2apb_virtual_sequence_base");
            super.new(name);
        endfunction 

        // body
        virtual task body ();
            ahb_seqr = p_sequencer.ahb_sequencer;
            apb_seqr = p_sequencer.apb_sequencer;
        endtask

    endclass 

`endif 