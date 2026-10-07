`ifndef AHB2APB_APB_CONFIG_OBJ_SV
    `define AHB2APB_APB_CONFIG_OBJ_SV

    class ahb2apb_apb_config_obj extends uvm_object;
        `uvm_object_utils(ahb2apb_apb_config_obj)
        uvm_active_passive_enum is_active;
        virtual ahb2apb_apb_vif vif;
        bit has_coverage;
        int unsigned stuck_threshold;

        function new(string name = "ahb2apb_apb_config_obj");
            super.new(name);
            is_active = UVM_ACTIVE;
            has_coverage = 1;
            stuck_threshold = 20;
        endfunction
    endclass
    
`endif