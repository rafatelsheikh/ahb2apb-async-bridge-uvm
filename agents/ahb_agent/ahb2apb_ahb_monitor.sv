`ifndef AHB2APB_AHB_MONITOR_SV
    `define AHB2APB_AHB_MONITOR_SV

/****************************************************
*This File represents the Monitor Component That    *
*Monitors That Interface and sends sequence item to *
*the Scoarboard.                                    *
*This File will Cover The Ovelab Conditions and Will*
*Gather The Inputs With its Outputs and Send them to*
*The Scoerboard at once                             *
******************************************************/

class ahb2apb_ahb_monitor extends uvm_monitor implements ahb2apb_reset_handler;
    virtual ahb2apb_ahb_if                      ahb_vif;
    ahb2apb_ahb_agent_config                    cfg;
    uvm_analysis_port #(ahb2apb_ahb_item_mon)   ap;

    protected process process_collect_transactions;

    `uvm_component_utils (ahb2apb_ahb_monitor)

    function new (string name = "ahb2apb_ahb_monitor", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        ap=new("ap",this);
        if(!uvm_config_db #(ahb2apb_ahb_agent_config)::get(this,"","CFG",cfg))
                `uvm_fatal("CFG_DB_GET_FAILED","Failed to get the Confegeration Object ...")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            fork
                begin
                  wait_reset_end();
                  collect_transactions();
                  disable fork;
                end 
        join
        end
    endtask
    // Transaction Monitoring
    protected virtual task collect_transaction(ahb2apb_ahb_item_mon seq_item);
        int unsigned waiting_temp;
        @(posedge ahb_vif.HCLK);
        while (ahb_vif.HREADY == 0) begin
            if (seq_item.is_in_progress)
                begin
                    seq_item.length ++;
                    if(seq_item.length >= cfg.get_stuck_threshold())
                        begin
                            `uvm_error("MON_TIMEOUT",$sformatf("Couldnot Get The Response For The Current Item.\n%s",this.convert2string))
                            waiting_temp = seq_item.waiting;
                            seq_item.reset_item();
                            seq_item.waiting = waiting_temp;
                        end
                end
                seq_item.waiting ++;
            @(posedge ahb_vif.HCLK);
        end
        if (ahb_vif.HWRITE == 1 && ahb_vif.HSEL)
            begin
                // If I am in write operation and I am Not idle or waiting for another process respose
                // Then sample The Inputs and When Hready is asserted again sample the response and the
                // outputs then sample the new inputs if the transfer not idle
                if (seq_item.is_in_progress == 0 && ahb_vif.HTRANS != 'b00)
                    begin
                        seq_item.reseted        = 0;
                        seq_item.is_in_progress = 1;

                        seq_item.hsel           = ahb_vif.HSEL;
                        seq_item.haddr          = ahb_vif.HADDR;
                        seq_item.htrans         = ahb2apb_ahb_trans'(ahb_vif.HTRANS);
                        seq_item.hsize          = ahb2apb_ahb_size'(ahb_vif.HSIZE);
                        seq_item.hprot          = ahb_vif.HPROT;
                        seq_item.hwrite         = ahb2apb_ahb_dir'(ahb_vif.HWRITE);
                        seq_item.hreadyout      = ahb_vif.HREADYOUT;
                        seq_item.hrdata         = ahb_vif.HRDATA;
                        seq_item.hresp          = ahb2apb_ahb_resp'(ahb_vif.HRESP);
                        @(posedge ahb_vif.HCLK)
                        seq_item.hwdata         = ahb_vif.HWDATA;
                        seq_item.hready         = ahb_vif.HREADY;
                        seq_item.length ++;
                        seq_item.waiting ++;
                        `uvm_info ("ITEM_START",$sformatf("Write Item In Progress ... \n%0s", seq_item.convert2string),UVM_LOW)
                        ap.write(seq_item);
                    end
                else
                    begin
                        if (seq_item.is_in_progress) begin
                            seq_item.is_in_progress = 0;

                            seq_item.hreadyout      = ahb_vif.HREADYOUT;
                            seq_item.hrdata         = ahb_vif.HRDATA;
                            seq_item.hresp          = ahb2apb_ahb_resp'(ahb_vif.HRESP);

                            `uvm_info ("ITEM_END",$sformatf("Write Item Output Ready ... \n%0s", seq_item.convert2string),UVM_LOW)
                            ap.write(seq_item);

                            waiting_temp = seq_item.waiting;
                            seq_item.reset_item();
                            seq_item.waiting = waiting_temp;
                        end
                        
                        // Start Of the Overlabbed Operation
                        if (ahb_vif.HTRANS != 'b00)
                            seq_item.is_in_progress = 1;
                        else 
                            seq_item.is_in_progress = 0;

                        seq_item.hsel           = ahb_vif.HSEL;
                        seq_item.haddr          = ahb_vif.HADDR;
                        seq_item.htrans         = ahb2apb_ahb_trans'(ahb_vif.HTRANS);
                        seq_item.hsize          = ahb2apb_ahb_size'(ahb_vif.HSIZE);
                        seq_item.hprot          = ahb_vif.HPROT;
                        seq_item.hwrite         = ahb2apb_ahb_dir'(ahb_vif.HWRITE);
                        seq_item.hreadyout      = ahb_vif.HREADYOUT;
                        seq_item.hrdata         = ahb_vif.HRDATA;
                        seq_item.hresp          = ahb2apb_ahb_resp'(ahb_vif.HRESP);

                        if (ahb_vif.HTRANS != 0) @(posedge ahb_vif.HCLK)
                        
                        seq_item.hwdata         = ahb_vif.HWDATA;
                        seq_item.hready         = ahb_vif.HREADY;
                        seq_item.length ++;
                        `uvm_info ("ITEM_START",$sformatf("Write Item In Progress ... \n%0s", seq_item.convert2string),UVM_LOW)
                        ap.write(seq_item);
                    end
            end
        else if (ahb_vif.HWRITE == 0 && ahb_vif.HSEL)
            begin
                // If I am in Read operation and I am Not idle or waiting for another process respose
                // Then sample The Inputs and When Hready is asserted again sample the response and the
                // outputs then sample the new inputs if the transfer not idle
                if (seq_item.is_in_progress == 0 && ahb_vif.HTRANS != 'b00)
                    begin
                        seq_item.reseted        = 0;
                        seq_item.is_in_progress = 1;

                        seq_item.hsel           = ahb_vif.HSEL;
                        seq_item.haddr          = ahb_vif.HADDR;
                        seq_item.htrans         = ahb2apb_ahb_trans'(ahb_vif.HTRANS);
                        seq_item.hsize          = ahb2apb_ahb_size'(ahb_vif.HSIZE);
                        seq_item.hprot          = ahb_vif.HPROT;
                        seq_item.hwrite         = ahb2apb_ahb_dir'(ahb_vif.HWRITE);
                        seq_item.hreadyout      = ahb_vif.HREADYOUT;
                        seq_item.hrdata         = ahb_vif.HRDATA;
                        seq_item.hresp          = ahb2apb_ahb_resp'(ahb_vif.HRESP);
                        seq_item.hwdata         = ahb_vif.HWDATA;
                        seq_item.hready         = ahb_vif.HREADY;
                        `uvm_info ("ITEM_START",$sformatf("Write Item In Progress ... \n%0s", seq_item.convert2string),UVM_LOW)
                        ap.write(seq_item);
                    end
                else
                    begin
                        if (seq_item.is_in_progress) begin
                            seq_item.is_in_progress = 0;

                            seq_item.hreadyout      = ahb_vif.HREADYOUT;
                            seq_item.hrdata         = ahb_vif.HRDATA;
                            seq_item.hresp          = ahb2apb_ahb_resp'(ahb_vif.HRESP);

                            `uvm_info ("ITEM_END",$sformatf("Write Item Output Ready ... \n%0s", seq_item.convert2string),UVM_LOW)
                            ap.write(seq_item);

                            waiting_temp = seq_item.waiting;
                            seq_item.reset_item();
                            seq_item.waiting = waiting_temp;
                        end
                        // Start Of the Overlabbed Operation
                        if (ahb_vif.HTRANS != 'b00)
                            seq_item.is_in_progress = 1;
                        else 
                            seq_item.is_in_progress = 0;

                        seq_item.hsel           = ahb_vif.HSEL;
                        seq_item.haddr          = ahb_vif.HADDR;
                        seq_item.htrans         = ahb2apb_ahb_trans'(ahb_vif.HTRANS);
                        seq_item.hsize          = ahb2apb_ahb_size'(ahb_vif.HSIZE);
                        seq_item.hprot          = ahb_vif.HPROT;
                        seq_item.hwrite         = ahb2apb_ahb_dir'(ahb_vif.HWRITE);
                        seq_item.hreadyout      = ahb_vif.HREADYOUT;
                        seq_item.hrdata         = ahb_vif.HRDATA;
                        seq_item.hresp          = ahb2apb_ahb_resp'(ahb_vif.HRESP);
                        seq_item.hwdata         = ahb_vif.HWDATA;
                        seq_item.hready         = ahb_vif.HREADY;
                        `uvm_info ("ITEM_START",$sformatf("Write Item In Progress ... \n%0s", seq_item.convert2string),UVM_LOW)
                        if (seq_item.htrans == IDLE)
                            `uvm_info ("ITEM_END",$sformatf("IDLE Transfere End ..."),UVM_LOW)
                        ap.write(seq_item);
                    end
            end
        else if (!ahb_vif.HSEL) 
            begin
                if (seq_item.is_in_progress && ahb_vif.HREADYOUT) 
                    begin
                        seq_item.is_in_progress = 0;

                        seq_item.hreadyout      = ahb_vif.HREADYOUT;
                        seq_item.hrdata         = ahb_vif.HRDATA;
                        seq_item.hresp          = ahb2apb_ahb_resp'(ahb_vif.HRESP);

                        `uvm_info ("ITEM_END",$sformatf("Write Item Output Ready ... \n%0s", seq_item.convert2string),UVM_LOW)
                        ap.write(seq_item);

                        waiting_temp = seq_item.waiting;
                        seq_item.reset_item();
                        seq_item.waiting = waiting_temp;
                    end
            end
    endtask

    protected virtual task collect_transactions();
      fork
            begin
                process_collect_transactions = process::self();
                
                ahb2apb_ahb_item_mon seq_item =ahb2apb_ahb_item_mon::type_id::create("seq_item");
                ahb_vif = cfg.get_vif;

                seq_item.reset_item();
                forever begin
                    collect_transaction(seq_item);  
                end
                
            end
      join
    endtask

    // Once Reset is asserted This task waits till its deassertion
    protected virtual task wait_reset_end();
      cfg.wait_reset_end();
    endtask

    // Once Reset is asserted This task Kills The Running Process
    virtual function void handle_reset(uvm_phase phase);
        if(process_collect_transactions != null) begin
            process_collect_transactions.kill();
            
            process_collect_transactions = null;
        end
    endfunction
endclass

`endif