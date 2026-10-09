`ifndef AHB2APB_VIRTUAL_SEQUENCE_WR_RANDOM_ERR_SV
    `define AHB2APB_VIRTUAL_SEQUENCE_RANDOM_ERR_SV

    class ahb2apb_virtual_sequence_wr_random_err extends ahb2apb_virtual_sequence_base;
        `uvm_object_utils(ahb2apb_virtual_sequence_wr_random_err)

        // sequences handles
        ahb2apb_ahb_sequence_random_rw ahb_seq;
        ahb2apb_apb_sequence_random_error apb_seq;

        // constructor
        function new (string name = "ahb2apb_virtual_sequence_wr_random_err");
            super.new(name);
        endfunction

        // body
        task body ();
            // building the sequences
            ahb_seq = ahb2apb_ahb_sequence_random_rw::type_id::create("ahb_seq");
            apb_seq = ahb2apb_apb_sequence_random_error::type_id::create("apb_seq");

            // ahb sequence number of iterations setting
            ahb_seq.num_iter = 1000;

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