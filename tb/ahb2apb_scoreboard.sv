`ifndef AHB2APB_SCOREBOARD_SV
    `define AHB2APB_SCOREBOARD_SV

        class ahb2apb_scoreboard extends uvm_scoreboard implements ahb2apb_reset_handler;
        `uvm_component_utils(ahb2apb_scoreboard)

            // analysis ports
            uvm_analysis_export #(ahb2apb_ahb_item_mon) axp_in_ahb; // from ahb agent
            uvm_analysis_export #(ahb2apb_apb_item_mon) axp_in_apb; // from apb agent
            // predictors 
            ahb2apb_apb_predictor prd_apb; // predict the expexted apb signals
            ahb2apb_ahb_predictor prd_ahb; // predict the expected ahb signals
            // filters
            ahb2apb_filter_apb_out apb_out_filter; // filter the apb signals to send output ones only
            ahb2apb_filter_ahb_out ahb_out_filter; // filter the ahb signals to send output ones only
            // comparator 
            ahb2apb_comparator cmp;

            // constructor
            function new (string name = "ahb2apb_scoreboard", uvm_component parent = null);
                super.new(name,parent);
            endfunction

            // build phase
            function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                axp_in_ahb = new("axp_in_ahb",this);
                axp_in_apb = new("axp_in_apb",this);
                prd_ahb = ahb2apb_ahb_predictor::type_id::create("prd_ahb",this);
                prd_apb = ahb2apb_apb_predictor::type_id::create("prd_apb",this);
                apb_out_filter = ahb2apb_filter_apb_out::type_id::create("apb_out_filter",this);
                ahb_out_filter = ahb2apb_filter_ahb_out::type_id::create("ahb_out_filter",this);
                cmp = ahb2apb_comparator::type_id::create("cmp",this);
            endfunction

            // connections
            function void connect_phase(uvm_phase phase);   
                super.connect_phase(phase);
                // items to predictors
                axp_in_ahb.connect(prd_apb.analysis_export);
                axp_in_apb.connect(prd_ahb.analysis_export);
                // items to filters
                axp_in_ahb.connect(ahb_out_filter.analysis_export); 
                axp_in_apb.connect(apb_out_filter.analysis_export); 
                // predictors to comparator
                prd_apb.ap_exp_apb.connect(cmp.axp_exp_apb); // fifo take the apb expected signals
                prd_ahb.ap_exp_ahb.connect(cmp.axp_exp_ahb); // fifo take the ahb expected signals               
                // filters to comparator
                apb_out_filter.ap_act_apb.connect(cmp.axp_act_apb); // fifo take the apb actual signals
                ahb_out_filter.ap_act_ahb.connect(cmp.axp_act_ahb); // fifo take the ahp actual signals
            endfunction

            // Handle reset
        virtual function void handle_reset (uvm_phase phase);
            cmp.handle_reset(phase);
            prd_apb.data_mem = 0; 
        endfunction

        endclass

    `endif 