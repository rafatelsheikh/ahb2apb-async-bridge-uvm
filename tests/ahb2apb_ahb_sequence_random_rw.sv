`ifndef AHB2ABP_AHB_SEQUENCE_RANDOM_RW_SV
    `define AHB2ABP_AHB_SEQUENCE_RANDOM_RW_SV

     class ahb2apb_ahb_sequence_random_rw extends uvm_sequence;
        `uvm_object_utils(ahb2apb_ahb_sequence_random_rw)
        `uvm_declare_p_sequencer(ahb2apb_ahb_sequencer)

        // number of consecutive writes
        int unsigned num_iter;
        // constructor
        function new(string name = "ahb2apb_ahb_sequence_random_rw");
            super.new(name);
            num_iter = 100;
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
                    if (!req1.randomize())
                        `uvm_fatal("RAND_FAILED", "Failed To randomise the Random Read/Write Request...")

                    finish_item(req1);
                end
        endtask
    endclass

`endif