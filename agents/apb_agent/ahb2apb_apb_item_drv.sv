`ifndef AHB2APB_APB_ITEM_DRV_SV
    `define AHB2APB_APB_ITEM_DRV_SV

    class ahb2apb_apb_item_drv extends uvm_sequence_item;
        //data members
        rand logic pslverr;
        rand logic [`AHB2APB_APB_MAX_DATA_WIDTH-1:0] prdata;
        rand int unsigned wait_states;   // number of extra ACCESS cycles with PREADY = 0
        rand int unsigned aftr_item_delay; // delay random after the item is processed

        //uvm_object_utils macros needed for methods
        `uvm_object_utils_begin(ahb2apb_apb_item_drv)
            `uvm_field_int(pslverr, UVM_ALL_ON)
            `uvm_field_int(prdata, UVM_ALL_ON)
            `uvm_field_int(wait_states, UVM_ALL_ON)
            `uvm_field_int(aftr_item_delay, UVM_ALL_ON)
        `uvm_object_utils_end

        function new(string name = "ahb2apb_apb_item_drv");
            super.new(name);
        endfunction

        //Constraints
        constraint pslverr_c     {soft pslverr dist {0:/90, 1:/10};}
        constraint wait_states_c {soft wait_states dist {0:/50, [1:3]:/40, [4:8]:/10};}
        constraint aftr_item_delay_c {soft aftr_item_delay inside {[1:5]};}

        function string convert2string();
            return $sformatf("%s, WAIT_STATES = %0d, PSLVERR = 0b%0b, PRDATA = 0x%0h",
            super.convert2string(), wait_states, pslverr, prdata);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("WAIT_STATES = %0d, PSLVERR = 0b%0b, PRDATA = 0x%0h",
            wait_states, pslverr, prdata);
        endfunction

    endclass

`endif