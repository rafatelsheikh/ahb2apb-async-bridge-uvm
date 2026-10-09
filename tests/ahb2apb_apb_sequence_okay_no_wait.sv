`ifndef AHB2APB_APB_SEQUENCE_OKAY_NO_WAIT_SV 
    `define AHB2APB_APB_SEQUENCE_OKAY_NO_WAIT_SV

    class ahb2apb_apb_sequence_okay_no_wait extends uvm_sequence #(ahb2apb_apb_item_drv);
        `uvm_object_utils(ahb2apb_apb_sequence_okay_no_wait)
        `uvm_declare_p_sequencer(ahb2apb_apb_sequencer)
        // Request and response
        ahb2apb_apb_item_mon seq_item_req;
        ahb2apb_apb_item_drv seq_item_res;

        // Constructor
        function new(string name = "ahb2apb_apb_sequence_okay_no_wait");
            super.new(name);
        endfunction 

        // body
        task body ();
            forever begin
                seq_item_req = ahb2apb_apb_item_mon::type_id::create("seq_item_req");
                seq_item_res = ahb2apb_apb_item_drv::type_id::create("seq_item_res");
                p_sequencer.request_fifo.get(seq_item_req);
                start_item(seq_item_res);

                // Inline constraints override the soft constraints in the item
                if (!seq_item_res.randomize() with {
                        pslverr     == 1'b0;   // always OKAY
                        wait_states == 0;      // no wait states
                    })
                    `uvm_fatal("RAND_FAILED", "Failed To randomize the no wait okay response ...")

                if (seq_item_req.pwrite) begin
                    seq_item_res.prdata = 0;    
                end 
                else begin
                    seq_item_res.prdata = $random(); 
                end

                finish_item(seq_item_res); 
            end
        endtask

    endclass

`endif