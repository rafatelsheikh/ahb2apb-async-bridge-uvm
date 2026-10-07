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
        virtual function void write(ahb2apb_ahb_item_mon t);
            ahb2apb_apb_item_mon exp_apb_item;
            `uvm_info("DEBUG","Write in APB prd analysis export",UVM_HIGH); //check monitor sending to the predictor 
            if (t.is_in_progress) begin 
                exp_apb_item = ahb2apb_apb_item_mon::type_id::create("exp_apb_item");
                calc_exp_apb(t,exp_apb_item);
                if (exp_apb_item.psel) begin
                    ap_exp_apb.write(exp_apb_item);    
                end
            end
        endfunction

        // calculate expected ahb function
        function void calc_exp_apb(input ahb2apb_ahb_item_mon in_data, inout ahb2apb_apb_item_mon exp_data);
            `uvm_info("DEBUG","CALC the expected APB signals called",UVM_HIGH); //check predictor call calc function
            // signals
            //------------------------
            // PSEL
            exp_data.psel = in_data.hsel && ((in_data.htrans == NONSEQ) || (in_data.htrans == SEQ)); 
            // HREADY neglected for PSEL as the monitor will send when operation happens so it is in meaning that it will always be high            
            
            //PADDR
            exp_data.paddr = {(in_data.haddr >> 2), 2'b00};
            
            // PWRITE
            exp_data.pwrite = (in_data.hwrite == AHB_WRITE);
            
            // PPROT
            exp_data.pprot = {~(in_data.hprot[0]), 1'b0, in_data.hprot[1]};

            // PWDATA
            exp_data.pwdata = in_data.hwdata;
            
            // PSTRB
            if (in_data.hwrite == AHB_WRITE) begin
                if (in_data.hsize == BYTE) begin
                    exp_data.pstrb = 4'b0001 << in_data.haddr[1:0]; 
                end 
                else if (in_data.hsize == HALF_WORD) begin
                    exp_data.pstrb = 4'b0011 << {in_data.haddr[1], 1'b0}; 
                end
                else if (in_data.hsize == WORD) begin
                    exp_data.pstrb = 4'b1111;
                end
                else begin
                    exp_data.pstrb = 4'b0;
                end    
            end
            else begin
                exp_data.pstrb = 4'b0;
            end  
            //--------------------------
        endfunction

    endclass

`endif 