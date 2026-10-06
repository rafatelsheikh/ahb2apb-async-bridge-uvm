`ifndef AHB2APB_SB_APB_PREDICTOR_SV
    `define AHB2APB_SB_APB_PREDICTOR_SV

    class ahb2apb_apb_predictor extends uvm_subscriber #(ahb2apb_ahb_item_mon);
        `uvm_component_utils(ahb2apb_apb_predictor)

        // analysis port send to comparator
        uvm_analysis_port #(ahb2apb_apb_item_mon) ap_exp_apb;

        // constructor
        function new (string name = "ahb2apb_apb_predictor", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        // build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ap_exp_apb = new("ap_exp_apb",this);
        endfunction

        // write function
        virtual function void write(ahb2apb_ahb_item_mon in_ahb_item);
            ahb2apb_apb_item_mon exp_apb_item;
            `uvm_info("DEBUG","Write in APB prd analysis export",UVM_HIGH); //check monitor sending to the predictor 
            if (in_ahb_item.is_in_progress) begin 
                exp_apb_item = ahb2apb_apb_item_mon::type_id::create("exp_apb_item");
                calc_exp_apb(in_ahb_item,exp_apb_item);
                ap_exp_apb.write(exp_apb_item);
            end
        endfunction

        // calculate expected ahb function
        function void calc_exp_apb(input ahb2apb_ahb_item_mon in_data, inout ahb2apb_apb_item_mon exp_data);
            `uvm_info("DEBUG","CALC the expected APB signals called",UVM_HIGH); //check predictor call calc function
            // signals
            //------------------------
            // PSEL
            exp_data.PSEL = in_data.HSEL & in_data.HTRANS[1]; 
            // HREADY neglected for PSEL as the monitor will send when operation happens so it is in meaning that it will always be high            
            
            //PADDR
            exp_data.PADDR = in_data.HADDR;
            
            // PWRITE
            exp_data.PWRITE = in_data.HWRITE;
            
            // PPROT
            exp_data.PPROT = {~(in_data.HPROT[0]), 1'b0, in_data.HPROT[1]};

            // PWDATA
            if (in_data.HWRITE) begin
                exp_data.PWDATA = in_data.HWDATA;
            end 
            else begin
                exp_data.PWDATA = 0;
            end
            
            // PSTRB
            if (in_data.HWRITE) begin
                if (in_data.HSIZE == 3'b000) begin
                    exp_data.PSTRB = 4'b0001 << in_data.HADDR[1:0]; 
                end 
                else if (in_data.HSIZE == 3'b001) begin
                    exp_data.PSTRB = 4'b0011 << {in_data.HADDR[1], 1'b0}; 
                end
                else if (in_data.HSIZE == 3'b010) begin
                    exp_data.PSTRB = 4'b1111;
                end
                else begin
                    exp_data.PSTRB = 4'b0;
                end    
            end
            else begin
                exp_data.PSTRB = 4'b0;
            end  
            //--------------------------
        endfunction

    endclass

`endif 