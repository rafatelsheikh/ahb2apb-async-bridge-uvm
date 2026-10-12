`ifndef AHB2APB_VIRTUAL_SEQUENCE_PARAMETERIZED_SV
    `define AHB2APB_VIRTUAL_SEQUENCE_PARAMETERIZED_SV

    class ahb2apb_virtual_sequence_parameterized #(type ahb_sequence_t = uvm_sequence, type apb_sequence_t = uvm_sequence) extends ahb2apb_virtual_sequence_base;
        `uvm_object_param_utils(ahb2apb_virtual_sequence_parameterized #(ahb_sequence_t, apb_sequence_t))

        // sequences handles
        ahb_sequence_t ahb_seq;
        apb_sequence_t apb_seq;

        // number of iterations variable
        protected int unsigned num_iter;

        // constructor
        function new (string name = "ahb2apb_virtual_sequence_parameterized");
            super.new(name);
            num_iter = 10;
        endfunction

        // body
        task body ();
            // building the sequences
            ahb_seq = ahb_sequence_t::type_id::create("ahb_seq");
            apb_seq = apb_sequence_t::type_id::create("apb_seq");

            // ahb sequence number of iterations setting
            ahb_seq.num_iter = num_iter;

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

        // num_iter getter
        virtual function int unsigned get_num_iter();
            return num_iter;
        endfunction

        // num_iter setter
        virtual function void set_num_iter(int unsigned num_iter);
            if (num_iter < 1) begin
                `uvm_fatal("ALGORITHM_ISSUE", "number of iterations must be greater than 0")
            end else begin
                this.num_iter = num_iter;
            end
        endfunction

    endclass

`endif 