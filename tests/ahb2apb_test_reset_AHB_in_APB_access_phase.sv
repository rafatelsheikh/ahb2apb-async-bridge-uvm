`ifndef AHB2APB_TEST_RESET_AHB_IN_APB_ACCESS_PHASE_SV
    `define AHB2APB_TEST_RESET_AHB_IN_APB_ACCESS_PHASE_SV

    // directed test : after transfer starts mark it as non vaild by reset the AHB side.
    class ahb2apb_test_reset_AHB_in_APB_access_phase extends ahb2apb_test_base;
        `uvm_component_utils(ahb2apb_test_reset_AHB_in_APB_access_phase)

        // constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        // run phase
        virtual task run_phase(uvm_phase phase);
            ahb2apb_ahb_vif ahb_vif = ahb_agent_config.get_vif();
            virtual ahb2apb_apb_if apb_vif = apb_agent_config.vif;

            ahb2apb_ahb_sequence_nonoverlapped_read ahb_read_seq;
            
            phase.raise_objection(this, "reset_AHB_in_APB_access_phase_TEST_DONE");
            #(100ns);

            // Reset AHB while a read request is in act.
            ahb_read_seq = ahb2apb_ahb_sequence_nonoverlapped_read::type_id::create("ahb_read_seq");
            ahb_read_seq.num_iter = 1;
            fork
                ahb_read_seq.start(env.v_seqr.ahb_sequencer);
            join_none

            wait (ahb_vif.HREADYOUT == 1'b0);
            @(posedge ahb_vif.HCLK);
            #1ns;
            ahb_vif.HRESETn = 1'b0;
            
            repeat (3) @(posedge ahb_vif.HCLK);
            #1ns;
            ahb_vif.HRESETn = 1'b1;
            
            repeat (6) @(posedge ahb_vif.HCLK);

            phase.drop_objection(this, "reset_AHB_in_APB_access_phase_TEST_DONE");
        endtask
    endclass

`endif
