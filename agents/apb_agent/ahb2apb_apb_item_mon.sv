// ahb2apb_apb_item_mon.sv

`ifndef AHB2APB_APB_ITEM_MON_SV
    `define AHB2APB_APB_ITEM_MON_SV

    class ahb2apb_apb_item_mon extends uvm_sequence_item;

        `uvm_object_utils(ahb2apb_apb_item_mon)

        // APB outputs of the bridge
        logic psel;
        logic penable;
        logic [`AHB2APB_APB_MAX_DATA_WIDTH-1:0] paddr;
        logic pwrite;
        logic [`AHB2APB_APB_MAX_DATA_WIDTH-1:0] pwdata;
        logic [3:0] pstrb;
        logic [2:0] pprot;
        logic apbactive;

        // APB inputs to the bridge
        logic        pready;
        logic [`AHB2APB_APB_MAX_DATA_WIDTH-1:0] prdata;
        logic        pslverr;

        bit is_in_progress;
        integer wait_cycle_cnt;

        function new(string name = "ahb2apb_apb_item_mon");
            super.new(name);
        endfunction

        // Print inputs
        function string in2string();
            return $sformatf(
                "PREADY=%0b PRDATA=%08h PSLVERR=%0b",
                 pready, prdata, pslverr
            );
        endfunction

        // Print outputs
        function string out2string();
            return $sformatf(
                "PSEL=%0b PENABLE=%0b PADDR=%08h PWRITE=%0b PWDATA=%08h PSTRB=%h PPROT=%h APBACTIVE=%0b",
                 psel,    penable,    paddr,     pwrite,    pwdata,     pstrb,   pprot,   apbactive
            );
        endfunction

        virtual function string convert2string;
            string str;

            // Append object base info
            str = super.convert2string(); 

            // Format transaction fields cleanly
            str = {str, $sformatf("\n--- [APB Monitor Item] ---")};
            str = {str, $sformatf("\n-------- [INPUTS] --------")};
            str = {str, $sformatf("\n pready    : %0b", pready)};
            str = {str, $sformatf("\n prdata    : %0h", prdata)};
            str = {str, $sformatf("\n pslverr : %0b", pslverr)};
            str = {str, $sformatf("\n------- [OUTPUTS] --------")};
            str = {str, $sformatf("\n psel      : %0b", psel)};
            str = {str, $sformatf("\n penable     : %0b", penable)};
            str = {str, $sformatf("\n paddr     : %0h", paddr)};
            str = {str, $sformatf("\n pwrite    : %0s", pwrite)};
            str = {str, $sformatf("\n pwdata    : %0b", pwdata)};
            str = {str, $sformatf("\n pprot     : %0h", pprot)};
            str = {str, $sformatf("\n pstrb     : %0h", pstrb)};
            str = {str, $sformatf("\n apbactive : %0h", apbactive)};
            str = {str, $sformatf("\n------- [CONTROL] --------")};
            str = {str, $sformatf("\n is_in_progress : %0b", is_in_progress)};
            str = {str, $sformatf("\n wait_cycle_cnt : %0d", wait_cycle_cnt)};

            return str;
        endfunction

        // Compare observed item & expected item
        virtual function bit do_compare(
            uvm_object rhs,
            uvm_comparer comparer
        );

            ahb2apb_apb_item_mon expected;

            if (!$cast(expected, rhs))
                return 0;

            if (paddr    !== expected.paddr    || pwrite   !== expected.pwrite   || 
                pwdata   !== expected.pwdata   || pstrb    !== expected.pstrb    || 
                pprot[2] !== expected.pprot[2] || pprot[0] !== expected.pprot[0])
                return 0;
            else
                return 1;
        endfunction

        virtual function void do_copy(uvm_object rhs);

            ahb2apb_apb_item_mon rhs_item;

            if (!$cast(rhs_item, rhs))
                `uvm_error("COPY", "Cast failed in do_copy")

            super.do_copy(rhs);

            psel      = rhs_item.psel;
            penable   = rhs_item.penable;
            paddr     = rhs_item.paddr;
            pwrite    = rhs_item.pwrite;
            pwdata    = rhs_item.pwdata;
            pstrb     = rhs_item.pstrb;
            pprot     = rhs_item.pprot;
            pready    = rhs_item.pready;
            prdata    = rhs_item.prdata;
            pslverr   = rhs_item.pslverr;
            apbactive = rhs_item.apbactive;

        endfunction
         
    endclass

`endif
