`ifndef AHB2APB_APB_CONFIG_OBJ_SV
    `define AHB2APB_APB_CONFIG_OBJ_SV

    class ahb2apb_apb_config_obj extends uvm_object;
        `uvm_object_utils(ahb2apb_apb_config_obj)
        uvm_active_passive_enum is_active;
        virtual ahb2apb_apb_if vif;
        bit has_coverage;
        bit has_checks;
        int unsigned stuck_threshold;

        function new(string name = "ahb2apb_apb_config_obj");
            super.new(name);
            is_active = UVM_ACTIVE;
            has_coverage = 1;
            has_checks = 0;
            stuck_threshold = 20;
        endfunction

        //Getter for the APB virtual interface
        virtual function virtual ahb2apb_apb_if get_vif();
            return vif;
        endfunction
        
        //Setter for the APB virtual interface
        virtual function void set_vif(virtual ahb2apb_apb_if value);
        if(vif == null) begin
            vif = value;
            
            set_has_checks(get_has_checks());
        end
        else begin
            `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the APB virtual interface more than once")
        end
        endfunction

        //Getter for the APB Active/Passive control
        virtual function uvm_active_passive_enum get_active_passive();
            return is_active;
        endfunction
        
        //Setter for the APB Active/Passive control
        virtual function void set_active_passive(uvm_active_passive_enum value);
            is_active = value;
        endfunction

        //Getter for the has_coverage control field
        virtual function bit get_has_coverage();
            return has_coverage;
        endfunction

        //Setter for the has_coverage control field  
        virtual function void set_has_coverage(bit value);
            has_coverage = value;
        endfunction

        //Getter for the has_checks control field
        virtual function bit get_has_checks();
            return has_checks;
        endfunction

        //Setter for the has_checks control field
        virtual function void set_has_checks(bit value);
            has_checks = value;
        endfunction

        //Getter for the stuck threshold
        virtual function int unsigned get_stuck_threshold();
            return stuck_threshold;
        endfunction

        //Setter for stuck threshold
        virtual function void set_stuck_threshold(int unsigned value);
            if(value <= 2) begin
            `uvm_error("ALGORITHM_ISSUE", $sformatf("Tried to set stuck_threshold to value %d but the minimum length of an APB transfer is 2", value))
            end
            
            stuck_threshold = value;
        endfunction

        //Task for waiting the reset to start
        virtual task wait_reset_start();
            if(vif.PRESETn !== 0) begin
                @(negedge vif.PRESETn);
            end
        endtask
        
        //Task for waiting the reset to be finished
        virtual task wait_reset_end();
            while(vif.PRESETn == 0) begin
                @(posedge vif.PCLK);
            end
        endtask


    endclass
    
`endif