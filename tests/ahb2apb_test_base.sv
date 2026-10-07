`ifndef AHB2APB_TEST_BASE_SV
    `define AHB2APB_TEST_BASE_SV

    class ahb2apb_test_base extends uvm_test;
        `uvm_component_utils(ahb2apb_test_base)

        // defining handles
        ahb2apb_env env;
        ahb2apb_ahb_agent_config ahb_agent_config;
        ahb2apb_apb_config_obj apb_agent_config;

        // contructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        // build phase
        virtual function void build_phase(uvm_phase phase);
            // creating handles for the virtual interfaces
            virtual ahb2apb_ahb_if ahb_vif;
            virtual ahb2apb_apb_if apb_vif;

            super.build_phase(phase);

            // building the handles
            env = ahb2apb_env::type_id::create("env", this);
            ahb_agent_config = ahb2apb_ahb_agent_config::type_id::create("ahb_agent_config");
            apb_agent_config = ahb2apb_apb_config_obj::type_id::create("apb_agent_config");

            // getting the virtual interfaces and put them into the agent config objects
            if (!uvm_config_db #(virtual ahb2apb_ahb_if)::get(this, "", "AHB_IF", ahb_vif)) begin
                `uvm_fatal("VIF_GET_FAILED", "The AHB virtual interface is not found in the config data base during the test build phase")
            end

            if (!uvm_config_db #(virtual ahb2apb_apb_if)::get(this, "", "APB_IF", apb_vif)) begin
                `uvm_fatal("VIF_GET_FAILED", "The APB virtual interface is not found in the config data base during the test build phase")
            end

            // setting the interfaces in the agent config objects
            ahb_agent_config.set_vif(ahb_vif);
            apb_agent_config.vif = apb_vif;

            // setting the agent config objects into the config data base
            uvm_config_db #(ahb2apb_ahb_agent_config)::set(this, "env.ahb_agt*", "CFG", ahb_agent_config);
            uvm_config_db #(ahb2apb_apb_config_obj)::set(this, "env.apb_agt*", "CFG", apb_agent_config);
        endfunction

        // start of simulation phase
        virtual function void start_of_simulation_phase(uvm_phase phase);
            super.start_of_simulation_phase(phase);
            this.print();
            factory.print();
        endfunction
    endclass

`endif