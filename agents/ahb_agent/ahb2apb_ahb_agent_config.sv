`ifndef AHB2APB_AHB_AGENT_CONFIG_SV
    `define AHB2APB_AHB_AGENT_CONFIG_SV

    class ahb2apb_ahb_agent_config extends uvm_object;

        `uvm_object_utils(ahb2apb_ahb_agent_config)

        //local vars 
        local ahb2apb_ahb_vif vif;
        local uvm_active_passive_enum active_passive;

        //Number of clock cycles after which AHB transfer is considered
        //stuck and an error is triggered
        local int unsigned stuck_threshold;
        
        // to enable or disaple coverage
        local bit has_coverage;


        function new(string name = "ahb_agent_config");
            super.new(name);  
            active_passive = UVM_ACTIVE;
            stuck_threshold = 200;
            has_coverage = 1;          
        endfunction

        // ************ helper functions ************

        // virtual interface setter function
        virtual function void set_vif(ahb2apb_ahb_vif value);
            if (vif == null) begin
                vif = value;    
            end
            else begin
                `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the AHB interface more than once")
            end
        endfunction

        // virtual interface getter function
        virtual function ahb2apb_ahb_vif get_vif();
            return vif;
        endfunction

        // active passive var setter function
        virtual function void set_active_passive(uvm_active_passive_enum value);
            active_passive = value;
        endfunction

        // active passive var getter function
        virtual function uvm_active_passive_enum get_active_passive();
            return active_passive;
        endfunction

        // stuck_threshold var setter function
        virtual function void set_stuck_threshold(int unsigned value);
            if (value < 2) begin
                `uvm_error("ALGORITHEM ISSUE", $sformatf("can not set stuck threshold to value %0d min AHB transfer is 2", value))
            end
            stuck_threshold = value;
        endfunction
    
        // stuck_threshold var getter function
        virtual function int unsigned get_stuck_threshold();
            return stuck_threshold;
        endfunction

        // has coverage setter
        virtual function void set_has_coverage(bit value);
            has_coverage = value;
        endfunction
        
        // has coverage getter
        virtual function bit get_has_coverage();
            return has_coverage;
        endfunction

    endclass 

`endif
