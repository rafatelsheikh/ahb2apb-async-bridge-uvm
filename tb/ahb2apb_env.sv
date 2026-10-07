`ifndef AHB2APB_ENV_SV
    `define AHB2APB_ENV_SV

    class ahb2apb_env extends uvm_env;
        `uvm_component_utils(ahb2apb_env)

        // Agents
        //---------------------
        // AHB
        ahb2apb_ahb_agent ahb_agt;
        //APB
        ahb2apb_apb_slave_agent apb_agt;
        //---------------------

        // scoreboard
        ahb2apb_scoreboard sb;

        // virtual sequencer
        ahb2apb_virtual_sequencer v_seqr;
        
        // constractor
        function new (string name = "ahb2apb_env", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        // build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ahb_agt = ahb2apb_ahb_agent::type_id::create("ahb_agt",this);
            apb_agt = ahb2apb_apb_slave_agent::type_id::create("apb_agt",this);
            sb = ahb2apb_scoreboard::type_id::create("sb",this);
            v_seqr = ahb2apb_virtual_sequencer::type_id::create("v_seqr", this);
        endfunction

        //connect phase
        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            ahb_agt.ap.connect(sb.axp_in_ahb);
            apb_agt.slave_agent_aport.connect(sb.axp_in_apb);
            v_seqr.ahb_sequencer = ahb_agt.ahb_sqr; //ahb seqrs
            v_seqr.apb_sequencer = apb_agt.sequencer; //apb seqrs
        endfunction

    endclass 
`endif 