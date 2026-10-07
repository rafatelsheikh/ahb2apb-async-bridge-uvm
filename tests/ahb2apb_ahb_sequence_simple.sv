`ifndef AHB2APB_AHB_SEQUENCE_SIMPLE_SV
    `define AHB2APB_AHB_SEQUENCE_SIMPLE_SV

    class ahb2apb_ahb_sequence_simple extends uvm_sequence;
        `uvm_object_utils(ahb2apb_ahb_sequence_simple)
        `uvm_declare_p_sequencer(ahb2apb_ahb_sequencer)

        // defining handles
        ahb2apb_ahb_item_drv item;
        ahb2apb_ahb_item_drv item_2;

        // constructor
        function new(string name = "ahb2apb_ahb_sequence_simple");
            super.new(name);
        endfunction

        // body
        virtual task body();
            item = ahb2apb_ahb_item_drv::type_id::create("item");
            item_2 = ahb2apb_ahb_item_drv::type_id::create("item_2");

            // starting the first item
            start_item(item);

            item.hsel = 1;
            item.hwrite = AHB_WRITE;
            item.htrans = NONSEQ;
            item.hsize = WORD;
            item.hprot = 0;
            item.haddr = $random();
            item.hwdata = $random();
            item.pre_drive_delay = 0;
            item.post_drive_delay = 0;

            finish_item(item);

            // starting the second item
            start_item(item_2);

            item_2.hsel = 1;
            item_2.hwrite = AHB_READ;
            item_2.htrans = NONSEQ;
            item_2.hsize = WORD;
            item_2.hprot = 0;
            item_2.haddr = $random();
            item_2.hwdata = 0;
            item_2.pre_drive_delay = 0;
            item_2.post_drive_delay = 0;

            finish_item(item_2);
        endtask
    endclass

`endif