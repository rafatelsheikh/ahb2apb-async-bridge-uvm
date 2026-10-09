`ifndef AHB2APB_VIRTUAL_SEQUENCE_WRITE_OVERLAPPED_SV
    `define AHB2APB_VIRTUAL_SEQUENCE_WRITE_OVERLAPPED_SV

    class ahb2apb_virtual_sequence_write_overlapped extends ahb2apb_virtual_sequence_base;
        `uvm_object_utils(ahb2apb_virtual_sequence_write_overlapped)

        // sequences handles
        ahb2apb_ahb_sequence_overlapped_write ahb_seq;
        ahb2apb_apb_sequence_okay_random_wait apb_seq;

        // constructor
        function new (string name = "ahb2apb_virtual_sequence_write_overlapped");
            super.new(name);
        endfunction

        // body
        task body ();
            // building the sequences
            ahb_seq = ahb2apb_ahb_sequence_overlapped_write::type_id::create("ahb_seq");
            apb_seq = ahb2apb_apb_sequence_okay_random_wait::type_id::create("apb_seq");

            // ahb sequence number of iterations setting
            ahb_seq.num_iter = 10;

            // executing sequences in parallel
            fork
                begin
                    ahb_seq.start(p_sequencer.ahb_sequencer);
                end

                begin
                    apb_seq.start(p_sequencer.apb_sequencer);
                end
            join_any

            #200

            disable fork;
        endtask

    endclass

`endif 