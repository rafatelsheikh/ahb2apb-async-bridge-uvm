`ifndef AHB2APB_TEST_SIMPLE_SV
    `define AHB2APB_TEST_SIMPLE_SV

    class ahb2apb_test_simple extends ahb2apb_test_base;
        `uvm_component_utils(ahb2apb_test_simple)

        // constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        // run phase
        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this, "SIMPLE_TEST_DONE");

            #(100ns);
            repeat (1) begin
                ahb2apb_virtual_sequence_simple seq = ahb2apb_virtual_sequence_simple::type_id::create("seq");

                seq.start(env.v_seqr);
            end
            #(100ns);

            phase.drop_objection(this, "SIMPLE_TEST_DONE");
        endtask
    endclass

`endif