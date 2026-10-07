`ifndef AHB2APB_VIRTUAL_SEQUENCE_SV
    `define AHB2APB_VIRTUAL_SEQUENCE_SV

    class ahb2apb_virtual_sequence_simple extends ahb2apb_virtual_sequence_base;
        `uvm_object_utils(ahb2apb_virtual_sequence_simple)

        // Master "AHB" sequence
        ahb2apb_ahb_sequence_simple ahb_seq;

        // Slave "APB" sequence
        ahb2apb_apb_sequence_simple apb_seq;

        // constructor
        function new (string name = "ahb2apb_virtual_sequence_simple");
            super.new(name);
        endfunction

        task body ();
            `uvm_info("DEBUG","Executing parallel sequences",UVM_HIGH)
            apb_seq = ahb2apb_apb_sequence_simple::type_id::create("apb_seq");
            ahb_seq = ahb2apb_ahb_sequence_simple::type_id::create("ahb_seq");
            // parallel sequences
            fork
                begin
                    apb_seq.start(p_sequencer.apb_sequencer);
                end
                begin
                    ahb_seq.start(p_sequencer.ahb_sequencer);
                end
            join_any
            #200
            disable fork;
        endtask

    endclass

`endif 