`ifndef AHB2APB_APB_ITEM_DRV_SV
    `define AHB2APB_APB_ITEM_DRV_SV

    class ahb2apb_apb_item_drv extends uvm_sequence_item;
        //data members
        rand logic PREADY;
        rand logic PSLVERR;
        rand logic [DATA_WIDTH-1:0] PRDATA;
        rand int unsigned prv_item_delay;
        rand int unsigned aftr_item_delay;

        //uvm_object_utils macros needed for methods
        `uvm_object_utils_begin(ahb2apb_apb_item_drv)
            `uvm_field_int(PREADY, UVM_ALL_ON)
            `uvm_field_int(PSLVERR, UVM_ALL_ON)
            `uvm_field_int(PRDATA, UVM_ALL_ON)
            `uvm_field_int(prv_item_delay, UVM_ALL_ON)
            `uvm_field_int(aftr_item_delay, UVM_ALL_ON)
        `uvm_object_utils_end
    

        function new(string name = "ahb2apb_apb_item_drv");
            super.new(name);
        endfunction

        //Constraints
        constraint PREADY_c {soft PREADY dist {0:/50, 1:/50};}
        constraint PSLVERR_c {soft PSLVERR dist {0:/90, 1:/10};}
        constraint prv_item_delay_c {soft prv_item_delay inside {[0:3]};}
        constraint aftr_item_delay_c {soft aftr_item_delay inside {[1:5]};}

        function string convert2string();
            return $sformatf("%s, PREADY = 0b%0b, PSLVERR = 0b%0b, PRDATA = 0b%0b", 
            super.convert2string(), PREADY, PSLVERR, PRDATA);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("PREADY = 0b%0b, PSLVERR = 0b%0b, PRDATA = 0b%0b",
            PREADY, PSLVERR, PRDATA);
        endfunction

    endclass

`endif
