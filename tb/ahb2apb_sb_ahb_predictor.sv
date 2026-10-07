`ifndef AHB2APB_SB_AHB_PREDICTOR_SV
    `define AHB2APB_SB_AHB_PREDICTOR_SV

    class ahb2apb_ahb_predictor extends uvm_subscriber #(ahb2apb_apb_item_mon);
        `uvm_component_utils(ahb2apb_ahb_predictor)

        // analysis port send to comparator
        uvm_analysis_port #(ahb2apb_ahb_item_mon) ap_exp_ahb;

        // constructor
        function new (string name = "ahb2apb_ahb_predictor", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        // build phase
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            ap_exp_ahb = new("ap_exp_ahb",this);
        endfunction

        // write function
        virtual function void write (ahb2apb_apb_item_mon t);
            ahb2apb_ahb_item_mon exp_ahb_item;
            `uvm_info("DEBUG","Write in AHB prd analysis export",UVM_HIGH); //check monitor sending to the predictor 
            if (!t.is_in_progress) begin 
                exp_ahb_item = ahb2apb_ahb_item_mon::type_id::create("exp_ahb_item");
                calc_exp_ahb(t,exp_ahb_item);
                ap_exp_ahb.write(exp_ahb_item);
            end
        endfunction

        // calculate expected ahb function
        function void calc_exp_ahb (input ahb2apb_apb_item_mon in_data, inout ahb2apb_ahb_item_mon exp_data);
            `uvm_info("DEBUG","CALC the expected AHB signals called",UVM_HIGH); //check predictor call calc function
            // signals
            // --------------------------
            // HREADYOUT
            exp_data.hreadyout = in_data.pready;
            
            // HRESP
            if(!($cast(exp_data.hresp, in_data.pslverr & in_data.pready))) 
                `uvm_fatal("CAST_FAILED","Casting expected HRESP tp its corresponding enum value failed")

            // HRDATA
            exp_data.hrdata = in_data.prdata;
            //------------------------
        endfunction

    endclass

`endif 