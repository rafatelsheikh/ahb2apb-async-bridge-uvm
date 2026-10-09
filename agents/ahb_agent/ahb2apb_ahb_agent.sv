`ifndef AHB2APB_AHB_AGENT_SV
    `define AHB2APB_AHB_AGENT_SV

/****************************************************
*This File represents the AHB Agent that Includes   *
*The Monitor, Driver and Coverage                   *
******************************************************/
class ahb2apb_ahb_agent extends uvm_agent implements ahb2apb_reset_handler;

    ahb2apb_ahb_driver ahb_drv;
    ahb2apb_ahb_sequencer ahb_sqr;
    ahb2apb_ahb_monitor ahb_mon;
    ahb2apb_ahb_coverage ahb_cov;

    ahb2apb_ahb_agent_config cfg;

    uvm_analysis_port #(ahb2apb_ahb_item_mon)   ap;

    `uvm_component_utils(ahb2apb_ahb_agent)

    function new (string name = "ahb2apb_ahb_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(ahb2apb_ahb_agent_config)::get(this,"","CFG",cfg))
            `uvm_fatal("CFG_DB_GET_FAILED","Failed to get the Confegeration Object ...")

        ap=new("ap",this);

        if (cfg.get_active_passive() == UVM_ACTIVE)
                begin
                    ahb_drv=ahb2apb_ahb_driver::type_id::create("ahb_drv",this);
                    ahb_sqr=ahb2apb_ahb_sequencer::type_id::create("ahb_sqr",this);
                end

        ahb_mon = ahb2apb_ahb_monitor::type_id::create("ahb_mon",this);

        if (cfg.get_has_coverage())
            ahb_cov = ahb2apb_ahb_coverage::type_id::create("ahb_cov",this);
            
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        if (cfg.get_active_passive() == UVM_ACTIVE)
            ahb_drv.seq_item_port.connect(ahb_sqr.seq_item_export);
        
        ahb_mon.ap.connect(ap);
        
        if (cfg.get_has_coverage())
            ahb_mon.ap.connect(ahb_cov.analysis_export);
    endfunction

    // Watches Till Reset is asserted
    protected virtual task wait_reset_start();
      cfg.wait_reset_start();
    endtask

    // Once Reset is asserted This task waits till its deassertion
    protected virtual task wait_reset_end();
      cfg.wait_reset_end();
    endtask

    // Implementaion of Reset Handling
    virtual function void handle_reset(uvm_phase phase);
        uvm_component children[$];
        
        get_children(children);
        
        foreach(children[idx]) begin
            ahb2apb_reset_handler reset_handler;
            
            if($cast(reset_handler, children[idx])) begin
                reset_handler.handle_reset(phase);
            end
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            wait_reset_start();
            handle_reset(phase);
            wait_reset_end();
        end
    endtask
endclass
`endif