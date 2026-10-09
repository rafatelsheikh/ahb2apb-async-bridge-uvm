`ifndef AHB2APB_SB_FILTER_APB_OUT_SV
    `define AHB2APB_SB_FILTER_APB_OUT_SV

    class ahb2apb_filter_apb_out extends uvm_subscriber #(ahb2apb_apb_item_mon);
        `uvm_component_utils(ahb2apb_filter_apb_out)
        
        // analysis port to comparetor
        uvm_analysis_port #(ahb2apb_apb_item_mon) ap_act_apb;

        //constructor
        function new(string name = "ahb2apb_filter_apb_out", uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        // build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ap_act_apb = new("ap_act_apb",this);
        endfunction

        // write function in the analysis export
        virtual function void write (ahb2apb_apb_item_mon t);
            ahb2apb_apb_item_mon in_cloned; 
            `uvm_info("DEBUG",$sformatf("Export of the APB filter has Is in progress: %b",t.is_in_progress),UVM_HIGH)
            // debug if the monitor send 2 output after each other or not 
            if (t.is_in_progress) begin
                if (!$cast(in_cloned, t.clone())) begin
                    `uvm_fatal("CAST_FAILED", "Failed to clone APB item")
                end
                ap_act_apb.write(in_cloned);
            end
        endfunction
        // Idea of the clone: to secure the data goes to fifo as if modified or killed 
        //                    in side the monitor it is kept in fifo without any change
    endclass 

`endif