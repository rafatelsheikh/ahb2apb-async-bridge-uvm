`ifndef AHB2ABP_AHB_SEQUENCE_NONOVERLAPPED_WRITE_SV
    `define AHB2ABP_AHB_SEQUENCE_NONOVERLAPPED_WRITE_SV

     class ahb2apb_ahb_sequence_nonoverlapped_write extends uvm_sequence;
        `uvm_object_utils(ahb2apb_ahb_sequence_nonoverlapped_write)
        `uvm_declare_p_sequencer(ahb2apb_ahb_sequencer)

        // number of consecutive writes
        int unsigned num_iter;
        // constructor
        function new(string name = "ahb2apb_ahb_sequence_nonoverlapped_write");
            super.new(name);
            num_iter = 20;
        endfunction

        // body
        virtual task body();
            ahb2apb_ahb_item_drv req1, req2;
            
            repeat(num_iter)
                begin
                    req1 = ahb2apb_ahb_item_drv::type_id::create("req1");
                    req2 = ahb2apb_ahb_item_drv::type_id::create("req2");
                    // Starting The First Request
                    start_item(req1);
                    if (!req1.randomize() with {
                                                    htrans == NONSEQ;
                                                    hwrite == AHB_WRITE;
                                                })
                        `uvm_fatal("RAND_FAILED", "Failed To randomise the non overlapped write Request...")

                    finish_item(req1);

                    // IDEL Transfer to seperate
                    start_item(req2);
                    if (!req2.randomize() with {
                                                    htrans == IDLE;
                                                    hwrite == AHB_WRITE;
                                                })
                        `uvm_fatal("RAND_FAILED", "Failed To randomise the non overlapped write Request...")

                    finish_item(req2);
                end
        endtask
    endclass

`endif