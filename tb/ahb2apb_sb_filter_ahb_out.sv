`ifndef AHB2APB_SB_FILTER_AHB_OUT_SV
    `define AHB2APB_SB_FILTER_AHB_OUT_SV

    class ahb2apb_filter_ahb_out extends uvm_subscriber #(ahb2apb_ahb_item_mon);
        `uvm_component_utils(ahb2apb_filter_ahb_out)
        
        // analysis port to comparetor
        uvm_analysis_port #(ahb2apb_ahb_item_mon) ap_act_ahb;

        //constructor
        function new(string name = "ahb2apb_filter_ahb_out", uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        // build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ap_act_ahb = new("ap_act_ahb",this);
        endfunction

        // write function in the analysis export
        virtual function void write (ahb2apb_ahb_item_mon ahb_out);
            `uvm_info("DEBUG",$sformatf("Export of the APB filter has Is in progress: %b",ahb_out.is_in_progress),UVM_HIGH)
            // debug if the monitor send 2 output after each other or not 
            if (!ahb_out.is_in_progress) begin
                ap_act_ahb.write(ahb_out);
            end
        endfunction
    
    endclass 

`endif