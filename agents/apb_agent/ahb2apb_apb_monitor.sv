// ahb2apb_apb_monitor.sv

`ifndef AHB2APB_APB_MONITOR_SV
    `define AHB2APB_APB_MONITOR_SV

    class ahb2apb_apb_monitor extends uvm_monitor;

        `uvm_component_utils(ahb2apb_apb_monitor)

        virtual ahb2apb_apb_if vif;
        ahb2apb_apb_config_obj cfg;
        integer stuck_threshold;

        // Sends observed requests to the sequencer FIFO
        uvm_analysis_port #(ahb2apb_apb_item_mon) request_aport;
        // Sends completed transfers 
        uvm_analysis_port #(ahb2apb_apb_item_mon) scoreboard_aport;
        // APB Memory
        ahb2apb_apb_mem memory;
        
        ahb2apb_apb_item_mon item_mon;
        ahb2apb_apb_item_mon item_done;   // completed item

        function new(string name = "ahb2apb_apb_monitor", uvm_component parent);
            super.new(name, parent);
            request_aport = new("request_aport", this);
            scoreboard_aport   = new("scoreboard_aport", this);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db#(ahb2apb_apb_config_obj)::get(this, "", "CFG", cfg))
            `uvm_fatal("CFG_DB_GET_FAILED", "APB Cingiguration Object not present")
            stuck_threshold = cfg.stuck_threshold;
            vif = cfg.vif;
        endfunction

        task run_phase(uvm_phase phase);
            forever begin
                @(posedge vif.PCLK);

                // Reset: drop 
                if (!vif.PRESETn) begin
                    memory.init();
                    continue;
                end

                // Setup phase
                if (vif.PSEL && !vif.PENABLE) begin
                    item_mon = ahb2apb_apb_item_mon::type_id::create("item_mon");
                    item_mon.is_in_progress = 0;
                    item_mon.paddr  = vif.PADDR;
                    item_mon.pwrite = vif.PWRITE;
                    item_mon.pprot  = vif.PPROT;
                    item_mon.pstrb  = vif.PSTRB;
                    item_mon.pwdata = vif.PWDATA;

                    request_aport.write(item_mon);

                    item_done = ahb2apb_apb_item_mon::type_id::create("item_done");
                    item_done.paddr  = vif.PADDR;
                    item_done.pwrite = vif.PWRITE;
                    item_done.pprot  = vif.PPROT;
                    item_done.pstrb  = vif.PSTRB;
                    item_done.pwdata = vif.PWDATA;

                    item_done.is_in_progress = 1;
                    item_done.wait_cycle_cnt = 0;
                    scoreboard_aport.write(item_done);   

                    `uvm_info ("ITEM_START",$sformatf("Setup phase: \n%0s", item_done.convert2string),UVM_LOW)                 
                end

                // Access phase
                else if (vif.PSEL && vif.PENABLE) begin
                    if (!item_done.is_in_progress) begin
                        `uvm_error("APB_MON", "PENABLE high without a preceding Setup phase")
                    end
                    else if (vif.PREADY) begin
                        // Last cycle of the transfer
                        // if (!item_done.pwrite)
                        item_done.prdata = vif.PRDATA;   // read data
                        item_done.pslverr = vif.PSLVERR; 
                        item_done.pready = vif.PREADY;

                        item_done.is_in_progress = 0;
                    
                        if (item_done.pwrite && !item_done.pslverr)
                            memory.write(item_done.paddr, item_done.pwdata, item_done.pstrb);

                        scoreboard_aport.write(item_done);
                        
                        `uvm_info ("ITEM_END",$sformatf("Access phase \n%0s", item_done.convert2string),UVM_LOW)
                        item_done.wait_cycle_cnt = 0;
                    end else begin
                        item_done.wait_cycle_cnt++;
                        if (item_done.wait_cycle_cnt >= stuck_threshold) begin
                            `uvm_error("MON_TIMEOUT", $sformatf("PREADY low for %0d cycles, dropping transfer", item_done.wait_cycle_cnt))
                            item_done.is_in_progress = 0;
                            item_done.wait_cycle_cnt  = 0;
                        end
                    end
                end
            end
        endtask 

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            memory.dump_to_file();
        endfunction
    
    endclass

`endif