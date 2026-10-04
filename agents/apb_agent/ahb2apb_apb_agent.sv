package apb_slave_agent_pkg;
    import uvm_pkg::*;
    import ahp2aph_apb_sequencer_pkg::*;
    import ahp2aph_apb_seq_item_pkg::*;
    import ahp2aph_apb_driver_pkg::*;
    import ahp2aph_apb_monitor_pkg::*;
    import ahp2aph_apb_config_pkg::*;
    `include "uvm_macros.svh"
    class apb_slave_agent extends uvm_agent;
        `uvm_component_utils(apb_slave_agent)
        ahp2aph_apb_sequencer sequencer;
        ahp2aph_apb_driver driver;
        ahp2aph_apb_monitor monitor;
        ahp2aph_apb_config config;
        uvm_analysis_port #(Seq_item) slave_agent_aport; //will care sequence item naming

        function new(string name = "apb_slave_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(ahp2aph_apb_config)::get(this, "", "CFG", config)) //will care config object key naming
                `uvm_fatal("build_phase", "Unable to Get Configuration Object")
            if (config.is_active == UVM_ACTIVE) begin
                sequencer = ahp2aph_apb_sequencer::type_id::create("sequencer",this);
                driver = ahp2aph_apb_driver::type_id::create("driver", this);
            end
            monitor = ahp2aph_apb_monitor::type_id::create("monitor", this);
            slave_agent_aport = new("slave_agent_aport", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            monitor.vif = config.vif;
            monitor.scoreboard_aport.connect(slave_agent_aport); //will care monitor analysis port naming
            if (config.is_active == UVM_ACTIVE) begin
                driver.vif = config.vif;
                driver.seq_item_port.connect(sequencer.seq_item_export); //will care sequence item request export naming
                monitor.request_aport.connect(sequencer.seq_item_export);
            end   
        endfunction
    endclass
endpackage