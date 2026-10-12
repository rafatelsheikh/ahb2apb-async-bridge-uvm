`ifndef AHB2APB_TEST_REQ_ACK_RECOVERY_SV
    `define AHB2APB_TEST_REQ_ACK_RECOVERY_SV

    // directed test : Ack, req missmatch
    class ahb2apb_test_req_ack_recovery extends ahb2apb_test_base;
        `uvm_component_utils(ahb2apb_test_req_ack_recovery)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            ahb2apb_ahb_vif ahb_vif = ahb_agent_config.get_vif();
            virtual ahb2apb_apb_if apb_vif = apb_agent_config.vif;
            ahb2apb_ahb_sequence_nonoverlapped_read ahb_read_seq;
            ahb2apb_apb_sequence_okay_no_wait apb_response_seq;

            phase.raise_objection(this, "REQ_ACK_RECOVERY_TEST_DONE");
            #(100ns);

            ahb_read_seq = ahb2apb_ahb_sequence_nonoverlapped_read::type_id::create("ahb_read_seq");
            apb_response_seq = ahb2apb_apb_sequence_okay_no_wait::type_id::create("apb_response_seq");
            ahb_read_seq.num_iter = 1;
            
             fork
                apb_response_seq.start(env.v_seqr.apb_sequencer);
            join_none

            ahb_read_seq.start(env.v_seqr.ahb_sequencer);

            wait (ahb_vif.HREADYOUT === 1'b1);
            wait ((apb_vif.PSEL === 1'b0) && (apb_vif.PENABLE === 1'b0));
            repeat (2) @(posedge ahb_vif.HCLK);

            apb_vif.PRESETn = 1'b0;
            repeat (3) @(posedge apb_vif.PCLK);
            #1ns;
            apb_vif.PRESETn = 1'b1;

            repeat (8) @(posedge ahb_vif.HCLK);

            disable fork;
            phase.drop_objection(this, "REQ_ACK_RECOVERY_TEST_DONE");
        endtask
    endclass

`endif
