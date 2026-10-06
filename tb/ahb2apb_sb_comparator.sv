`ifndef AHB2APB_SB_COMPARATOR_SV
    `define AHB2APB_SB_COMPARATOR_SV

    class ahb2apb_comparator extends uvm_component;
        `uvm_component_utils(ahb2apb_comparator)

        // analysis ports and fifos
        //---------------------------------
        //expected ahb signals
        uvm_analysis_export #(ahb2apb_ahb_item_mon) axp_exp_ahb;  
        uvm_tlm_analysis_fifo #(ahb2apb_ahb_item_mon) fifo_exp_ahb;
        // actual ahb signals
        uvm_analysis_export #(ahb2apb_ahb_item_mon) axp_act_ahb;  
        uvm_tlm_analysis_fifo #(ahb2apb_ahb_item_mon) fifo_act_ahb;
        //expected apb signals
        uvm_analysis_export #(ahb2apb_apb_item_mon) axp_exp_apb;  
        uvm_tlm_analysis_fifo #(ahb2apb_apb_item_mon) fifo_exp_apb;
        // actual apb signals
        uvm_analysis_export #(ahb2apb_apb_item_mon) axp_act_apb;  
        uvm_tlm_analysis_fifo #(ahb2apb_apb_item_mon) fifo_act_apb;
        
        // constructor
        function new(string name = "ahb2apb_comparator", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        // build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // expected ahb item export & fifo
            axp_exp_ahb = new("axp_exp_ahb",this); 
            fifo_exp_ahb = new("fifo_exp_ahb",this);
            // actual ahb item export & fifo
            axp_act_ahb = new("axp_act_ahb",this);
            fifo_act_ahb = new("fifo_act_ahb",this);
            // expected apb item export & fifo
            axp_exp_apb = new("axp_exp_apb",this);
            fifo_exp_apb = new("fifo_exp_apb",this);
            // actual apb item export & fifo
            axp_act_apb = new("axp_act_apb",this);
            fifo_act_apb = new("fifo_act_apb",this);            
        endfunction

        // connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            // connect fifo to the export
            axp_exp_ahb.connect(fifo_exp_ahb.analysis_export);
            axp_act_ahb.connect(fifo_act_ahb.analysis_export);
            axp_exp_apb.connect(fifo_exp_apb.analysis_export);
            axp_act_apb.connect(fifo_act_apb.analysis_export);
        endfunction

        // run phase
        task run_phase (uvm_phase phase);
            ahb2apb_apb_item_mon exp_apb_item, act_apb_item;
            ahb2apb_ahb_item_mon exp_ahb_item, act_ahb_item;
            super.run_phase(phase);
            forever begin
                fifo_exp_apb.get(exp_apb_item);
                fifo_act_apb.get(act_apb_item);
                fifo_exp_ahb.get(exp_ahb_item);
                fifo_act_ahb.get(act_ahb_item);
                if (act_apb_item.compare(exp_apb_item)) begin
                    PASS_APB();
                end 
                else begin
                    ERROR_APB(exp_apb_item.in2string(),exp_apb_item.out2string(),act_apb_item.out2string());
                end
                if (act_ahb_item.compare(exp_ahb_item)) begin
                    PASS_AHB();
                end 
                else begin
                    ERROR_AHB(exp_ahb_item.in2string(),exp_ahb_item.out2string(),act_ahb_item.out2string());
                end
            end
        endtask

        // counters 
        int AHB_correct_count,APB_correct_count, AHB_error_count, APB_error_count;

        // Pass functions
        //---------------------------
        // For APB
        function void PASS_APB();
            APB_correct_count++;
            `uvm_info("SCB_MATCH","All expected signals for APB interface match the output ones",UVM_HIGH)
        endfunction
        // For AHB
        function void PASS_AHB();
            AHB_correct_count++;
            `uvm_info("SCB_MATCH","All expected signals for AHB interface match the output ones",UVM_HIGH)
        endfunction
        //---------------------------

        // Error functions
        //---------------------------
        // For APB
        function void ERROR_APB(input string in_signals, exp_out_signals, act_out_signals);
            string msg;
            APB_error_count++;
            msg = $sformatf("The output signals in APB interface not match the expected ones\n  INPUT    : %s\n  EXPECTED : %s\n  ACTUAL   : %s",
                                                                                                in_signals,     exp_out_signals, act_out_signals);
            `uvm_error("SCB_MISMATCH",msg)
        endfunction
        // For AHB
        function void ERROR_AHB(input string in_signals, exp_out_signals, act_out_signals);
            string msg;
            AHB_error_count++;
            msg = $sformatf("The output signals in AHB interface not match the expected ones\n  INPUT    : %s\n  EXPECTED : %s\n  ACTUAL   : %s",
                                                                                                in_signals,     exp_out_signals, act_out_signals);
            `uvm_error("SCB_MISMATCH",msg)
        endfunction
        //---------------------------

        // reprot phase
        function void report_phase(uvm_phase phase);
            string rpt;
            int total_errors;
            int total_correct;
            int total_checks;
            super.report_phase(phase);
            //counters calc
            total_errors  = AHB_error_count + APB_error_count;
            total_correct = AHB_correct_count + APB_correct_count;
            total_checks = total_errors + total_correct;
            // report message
            rpt = $sformatf({
                "\n",
                "============================================================\n",
                "                AHB2APB BRIDGE SCOREBOARD REPORT\n",
                "============================================================\n",
                "    AHB output matched           : %0d\n",
                "    AHB output mismatches        : %0d\n",
                "    APB output matched           : %0d\n",
                "    APB output mismatches        : %0d\n",
                "------------------------------------------------------------\n",
                "    Total checks                 : %0d\n",
                "    Total matched                : %0d\n",
                "    Total mismatches             : %0d\n",
                "------------------------------------------------------------\n",
                "    RESULT                       : %s\n",
                "============================================================"},
                AHB_correct_count, AHB_error_count,
                APB_correct_count, APB_error_count,
                total_checks, total_correct, total_errors,
                (total_errors == 0) ? "PASS" : "FAIL");

            `uvm_info("AHB2APB_SCB_REPORT", rpt, UVM_LOW);
        endfunction

    endclass 

`endif 