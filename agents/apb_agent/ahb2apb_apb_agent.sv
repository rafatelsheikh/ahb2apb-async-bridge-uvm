`ifndef AHB2APB_APB_SLAVE_AGENT_SV
    `define AHB2APB_APB_SLAVE_AGENT_SV
    class ahb2apb_apb_slave_agent extends uvm_agent implements ahb2apb_reset_handler;
        `uvm_component_utils(ahb2apb_apb_slave_agent)

        //class handles the slave side of the APB interface.
        ahb2apb_apb_sequencer sequencer;
        ahb2apb_apb_driver driver;
        ahb2apb_apb_monitor monitor;
        ahb2apb_apb_config_obj cfg;
        ahb2apb_apb_coverage coverage;
        uvm_analysis_port #(ahb2apb_apb_item_mon) slave_agent_aport;

        //Constructor for the slave agent
        function new(string name = "ahb2apb_apb_slave_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        //Build phase of the slave agent
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //get the configuration object from the database
            if (!uvm_config_db #(ahb2apb_apb_config_obj)::get(this, "", "CFG", cfg))
                `uvm_fatal("CFG_DB_GET_FAILED", "Unable to Get APB Configuration Object")

            //Build sequencer and driver if the agent is active
            if (cfg.is_active == UVM_ACTIVE) begin
                sequencer = ahb2apb_apb_sequencer::type_id::create("sequencer",this);
                driver = ahb2apb_apb_driver::type_id::create("driver", this);
            end

            //Build monitor
            monitor = ahb2apb_apb_monitor::type_id::create("monitor", this);

            //Build Memory
            memory = ahb2apb_apb_mem::type_id::create("memory", this);

            //Build coverage if the configuration object has coverage enabled
            if (cfg.has_coverage)
                coverage = ahb2apb_apb_coverage::type_id::create("coverage", this);

            //Build the analysis port for the slave agent
            slave_agent_aport = new("slave_agent_aport", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            monitor.vif = cfg.vif;
            monitor.scoreboard_aport.connect(slave_agent_aport); // monitor -> agent analysis port
            monitor.memory = memory;

            if (cfg.is_active == UVM_ACTIVE) begin
                driver.vif = cfg.vif;
                driver.cfg = cfg;
                sequencer.memory = memory;
                driver.seq_item_port.connect(sequencer.seq_item_export);  // driver <-> sequencer
                monitor.request_aport.connect(sequencer.request_export);  // monitor -> sequencer FIFO
            end

            if (cfg.has_coverage)
                monitor.scoreboard_aport.connect(coverage.analysis_export); // monitor -> coverage
        endfunction

        //Function to handle the reset
        virtual function void handle_reset(uvm_phase phase);
        uvm_component children[$];
        
        get_children(children); //get the components
        
        foreach(children[idx]) begin
            ahb2apb_reset_handler reset_handler;
            
            if($cast(reset_handler, children[idx])) begin
            reset_handler.handle_reset(phase);
            end
        end
        endfunction

        //Task for waiting the reset to start
        protected virtual task wait_reset_start();
            cfg.wait_reset_start();
        endtask
            
        //Task for waiting the reset to be finished
        protected virtual task wait_reset_end();
            cfg.wait_reset_end();
        endtask
        
        virtual task run_phase(uvm_phase phase);
        forever begin
            wait_reset_start();
            handle_reset(phase);
            wait_reset_end();
        end
        endtask
    endclass



`endif
