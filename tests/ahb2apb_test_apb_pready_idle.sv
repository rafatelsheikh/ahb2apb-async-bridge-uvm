`ifndef AHB2APB_TEST_APB_PREADY_IDLE_SV
    `define AHB2APB_TEST_APB_PREADY_IDLE_SV

    // directed test : keep pready high for extra cycle after transfer ends.
    class ahb2apb_test_apb_pready_idle extends ahb2apb_test_base;

        `uvm_component_utils(ahb2apb_test_apb_pready_idle)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);

            ahb2apb_ahb_sequence_nonoverlapped_read ahb_seq;
            ahb2apb_apb_sequence_okay_no_wait_hold_pready apb_seq;

            ahb_seq = ahb2apb_ahb_sequence_nonoverlapped_read::type_id::create("ahb_seq");
            apb_seq = ahb2apb_apb_sequence_okay_no_wait_hold_pready::type_id::create("apb_seq");
            ahb_seq.num_iter = 1;
            phase.raise_objection(this, "FOLLOW_HOLES_TEST_DONE");
            #100
            fork
                begin
                    fork
                        begin
                            ahb_seq.start(env.v_seqr.ahb_sequencer);
                        end

                        begin
                            apb_seq.start(env.v_seqr.apb_sequencer);
                        end

                    join_any
                     #100;
                   
                end    
            join
            
            phase.drop_objection(this, "FOLLOW_HOLES_TEST_DONE");

        endtask

    endclass

`endif