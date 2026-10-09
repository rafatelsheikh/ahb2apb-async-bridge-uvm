`ifndef AHB2APB_TEST_MAIN_SV
    `define AHB2APB_TEST_MAIN_SV

    class ahb2apb_test_main extends ahb2apb_test_base;
        `uvm_component_utils(ahb2apb_test_main)

        // constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        // run phase
        virtual task run_phase(uvm_phase phase);
            // non overlapped write no wait test
            phase.raise_objection(this, "MAIN_TEST_DONE");

            #(100ns);

            `uvm_info("TEST", "non overlapped write no wait test started", UVM_LOW)

            begin
                ahb2apb_virtual_sequence_write_no_wait seq = ahb2apb_virtual_sequence_write_no_wait::type_id::create("seq");
                seq.start(env.v_seqr);
            end

            `uvm_info("TEST", "non overlapped write no wait test ended", UVM_LOW)

            #(100ns);

            // non overlapped write wait test

            `uvm_info("TEST", "non overlapped write wait test started", UVM_LOW)

            begin
                ahb2apb_virtual_sequence_write_wait seq = ahb2apb_virtual_sequence_write_wait::type_id::create("seq");
                seq.start(env.v_seqr);
            end

            `uvm_info("TEST", "non overlapped write wait test ended", UVM_LOW)

            #(100ns);

            // overlapped write wait test

            `uvm_info("TEST", "overlapped write wait test ended", UVM_LOW)

            begin
                ahb2apb_virtual_sequence_write_overlapped seq = ahb2apb_virtual_sequence_write_overlapped::type_id::create("seq");
                seq.start(env.v_seqr);
            end

            `uvm_info("TEST", "overlapped write wait test ended", UVM_LOW)

            #(100ns);

            // non overlapped read no wait test
            
            `uvm_info("TEST", "non overlapped read no wait test started", UVM_LOW)

            begin
                ahb2apb_virtual_sequence_read_no_wait seq = ahb2apb_virtual_sequence_read_no_wait::type_id::create("seq");
                seq.start(env.v_seqr);
            end

            `uvm_info("TEST", "non overlapped read no wait test ended", UVM_LOW)

            #(100ns);

            // non overlapped read wait test
            
            `uvm_info("TEST", "non overlapped read wait test starteded", UVM_LOW)

            begin
                ahb2apb_virtual_sequence_read_wait seq = ahb2apb_virtual_sequence_read_wait::type_id::create("seq");
                seq.start(env.v_seqr);
            end

            `uvm_info("TEST", "non overlapped read wait test ended", UVM_LOW)

            #(100ns);

            // overlapped read wait test

            `uvm_info("TEST", "overlapped read wait test started", UVM_LOW)

            begin
                ahb2apb_virtual_sequence_read_overlapped seq = ahb2apb_virtual_sequence_read_overlapped::type_id::create("seq");
                seq.start(env.v_seqr);
            end

            `uvm_info("TEST", "overlapped read wait test ended", UVM_LOW)

            #(100ns);

            // write read okay test

            `uvm_info("TEST", "write read okay test started", UVM_LOW)

            begin
                ahb2apb_virtual_sequence_wr_okay seq = ahb2apb_virtual_sequence_wr_okay::type_id::create("seq");
                seq.start(env.v_seqr);
            end

            `uvm_info("TEST", "write read okay test ended", UVM_LOW)

            #(100ns);

            // write read random error test
            `uvm_info("TEST", "write read random error test started", UVM_LOW)

            begin
                ahb2apb_virtual_sequence_wr_random_err seq = ahb2apb_virtual_sequence_wr_random_err::type_id::create("seq");
                seq.start(env.v_seqr);
            end

            `uvm_info("TEST", "write read random error test ended", UVM_LOW)

            #(100ns);

            // reset test
            `uvm_info("TEST", "rest test started", UVM_LOW)

            fork
                begin
                    ahb2apb_ahb_vif ahb_vif = ahb_agent_config.get_vif();
                    virtual ahb2apb_apb_if apb_vif = apb_agent_config.vif;

                    repeat (100) begin
                       // AHB clock reset assertion
                        repeat (30) begin
                            @(posedge ahb_vif.HCLK);
                        end

                        #(3ns);

                        ahb_vif.HRESETn = 0;
                        apb_vif.PRESETn = 0;

                        repeat (5) begin
                            @(posedge ahb_vif.HCLK);
                        end

                        #(2ns);

                        ahb_vif.HRESETn = 1;
                        apb_vif.PRESETn = 1;

                        // APB clock reset assertion
                        repeat (50) begin
                            @(posedge apb_vif.PCLK);
                        end

                        #(1ns);

                        ahb_vif.HRESETn = 0;
                        apb_vif.PRESETn = 0;

                        repeat (5) begin
                            @(posedge apb_vif.PCLK);
                        end

                        #(4ns);

                        ahb_vif.HRESETn = 1;
                        apb_vif.PRESETn = 1;

                        repeat (20) begin
                            @(posedge apb_vif.PCLK);
                        end 
                    end
                end

                begin
                    forever begin
                        ahb2apb_virtual_sequence_wr_random_err seq = ahb2apb_virtual_sequence_wr_random_err::type_id::create("seq");
                        seq.start(env.v_seqr);    
                    end
                end
            join_any

            disable fork;

            `uvm_info("TEST", "rest test ended", UVM_LOW)

            #(100ns);

            phase.drop_objection(this, "MAIN_TEST_DONE");
        endtask
    endclass

`endif