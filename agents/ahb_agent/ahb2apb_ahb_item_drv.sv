`ifndef AHB2APB_AHB_ITEM_DRV_SV
    `define AHB2APB_AHB_ITEM_DRV_SV

    class ahb2apb_ahb_item_drv extends uvm_sequence_item;

        // selection
        rand logic hsel;
        // direction
        rand ahb2apb_ahb_dir hwrite;
        // transfer type
        rand ahb2apb_ahb_trans htrans;
        // size 
        rand ahb2apb_ahb_size hsize;
        // protection
        rand logic [3:0] hprot;
        // address
        rand ahb2apb_ahb_addr haddr;
        // data
        rand ahb2apb_ahb_data hwdata;
        
        // pre&post item delays
        rand int unsigned pre_drive_delay;
        rand int unsigned post_drive_delay;

        // ** constraints **
        constraint pre_drive_delay_default {
            soft pre_drive_delay <= 5;
        }

        constraint post_drive_delay_default {
            soft post_drive_delay <= 5;
        }

        constraint selection_default {
            soft hsel dist {1 := 95, 0 := 5};
        }

        constraint direction_default {
            soft hwrite dist {AHB_WRITE := 60, AHB_READ := 40};
        }

        constraint transfer_type_default {
            soft htrans dist {IDLE := 40, NONSEQ := 60};
        }

        constraint transfer_size_default {
            soft hsize dist {BYTE := 20, HALF_WORD := 20, WORD := 60};
        }
        constraint transfer_size_offset_validation {
            (hsize == WORD)      -> haddr[1:0] == 2'b00;
            (hsize == HALF_WORD) -> haddr[0]   == 1'b0;
        }


        // macros for factory register & helper functions implementation (copy, compare, ...etc)
        `uvm_object_utils_begin(ahb2apb_ahb_item_drv)
            `uvm_field_enum(ahb2apb_ahb_dir,   hwrite, UVM_ALL_ON)
            `uvm_field_enum(ahb2apb_ahb_trans, htrans, UVM_ALL_ON)
            `uvm_field_enum(ahb2apb_ahb_size,  hsize,  UVM_ALL_ON)
            `uvm_field_int (hprot,                     UVM_ALL_ON)
            `uvm_field_int (hsel,                      UVM_ALL_ON)
            `uvm_field_int (haddr,                     UVM_ALL_ON)
            `uvm_field_int (hwdata,                    UVM_ALL_ON)
            `uvm_field_int (pre_drive_delay,           UVM_ALL_ON)
            `uvm_field_int (post_drive_delay,          UVM_ALL_ON)
        `uvm_object_utils_end    

        function new(name = "ahb_item_drv");
            super.new(name);            
        endfunction

        // convert2string function 
        virtual function string convert2string();
            string result = $sformatf("dir:%0s, transfer_type:%0s, Size:%0s, addr:%0x",
            hwrite, htrans, hsize, haddr);
            
            if(hwrite == AHB_WRITE) begin
                result = $sformatf("%s, data: %0x", result, hwdata);
            end
            
            result = $sformatf("%s, pre_drive_delay: %0d, post_drive_delay: %0d", 
                                result, pre_drive_delay, post_drive_delay);

            return result;
        endfunction

    endclass 

`endif