`ifndef AHB2APB_TEST_RESET_SV
    `define AHB2APB_TEST_RESET_SV

    class ahb2apb_test_reset extends ahb2apb_test_base;
        `uvm_component_utils(ahb2apb_test_reset)

        // constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        // run phase
        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this, "RESET_TEST_DONE");

            #(100ns);

            fork
                begin
                    ahb2apb_ahb_vif ahb_vif = ahb_agent_config.get_vif();
                    virtual ahb2apb_apb_if apb_vif = apb_agent_config.vif;

                    // AHB clock reset assertion
                    repeat (3) begin
                        @posedge(ahb_vif.HCLK);
                    end

                    #(3ns);

                    ahb_vif.HRESETn = 0;
                    apb_vif.PRESETn = 0;

                    repeat (5) begin
                        @posedge(ahb_vif.HCLK)
                    end

                    #(2ns);

                    ahb_vif.HRESETn = 1;
                    apb_vif.PRESETn = 1;

                    // APB clock reset assertion
                    repeat (20) begin
                        @posedge(apb_vif.PCLK);
                    end

                    #(1ns);

                    ahb_vif.HRESETn = 0;
                    apb_vif.PRESETn = 0;

                    repeat (5) begin
                        @posedge(apb_vif.PCLK)
                    end

                    #(4ns);

                    ahb_vif.HRESETn = 1;
                    apb_vif.PRESETn = 1;

                    repeat (20) begin
                        @posedge(apb_vif.PCLK);
                    end
                end

                begin
                    ahb2apb_virtual_sequence_wr_random_err seq = ahb2apb_virtual_sequence_wr_random_err::type_id::create("seq");
                    seq.start(env.v_seqr);
                end
            join_any

            disable_fork;

            #(100ns);

            phase.drop_objection(this, "RESET_TEST_DONE");
        endtask
    endclass

`endif