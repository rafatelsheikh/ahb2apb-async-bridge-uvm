`ifndef AHB2APB_APB_SLAVE_AGENT_SV
    `define AHB2APB_APB_SLAVE_AGENT_SV
    class ahb2apb_apb_slave_agent extends uvm_agent;
        `uvm_component_utils(ahb2apb_apb_slave_agent)

        //class handles the slave side of the APB interface.
        ahb2apb_apb_driver driver;
        ahb2apb_apb_monitor monitor;
        ahb2apb_apb_config_obj config;
        uvm_analysis_port #(ahb2apb_apb_item_drv) slave_agent_aport;

        function new(string name = "ahb2apb_apb_slave_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(ahb2apb_apb_config_obj)::get(this, "", "CFG", config))
                `uvm_fatal("apb_slave_agent_build_phase", "Unable to Get Configuration Object")

            if (config.is_active == UVM_ACTIVE) begin
                sequencer = ahb2apb_apb_sequencer::type_id::create("sequencer",this);
                driver = ahb2apb_apb_driver::type_id::create("driver", this);
            end

            monitor = ahb2apb_apb_monitor::type_id::create("monitor", this);
            slave_agent_aport = new("slave_agent_aport", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            monitor.vif = config.vif;
            monitor.scoreboard_aport.connect(slave_agent_aport);
            if (config.is_active == UVM_ACTIVE) begin
                driver.vif = config.vif;
                driver.seq_item_port.connect(sequencer.seq_item_export); 
                monitor.request_aport.connect(sequencer.seq_item_export);
            end   
        endfunction
    endclass

`endif