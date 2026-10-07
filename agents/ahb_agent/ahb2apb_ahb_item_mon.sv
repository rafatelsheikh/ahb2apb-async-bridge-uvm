`ifndef AHB2APB_ITEM_MON_SV
    `define AHB2APB_ITEM_MON_SV

/****************************************************
*This File represents the Sequence item that will be* 
*used in AHB_Monitor and then sent through the      *
*analysis port to scoreboard and coverage           *
******************************************************/
class ahb2apb_ahb_item_mon extends uvm_sequence_item;

    // ahb signals
    // Input Signals
    bit                                         hsel;
    logic   [`AHB2APB_AHB_MAX_ADDR_WIDTH-1 : 0] haddr;
    ahb2apb_ahb_trans                           htrans;
    ahb2apb_ahb_size                            hsize;
    logic   [3:0]                               hprot;
    ahb2apb_ahb_dir                             hwrite;
    bit                                         hready;
    logic   [`AHB2APB_AHB_MAX_DATA_WIDTH-1 : 0] hwdata;

    // Output Signals
    bit                                         hreadyout;
    logic   [`AHB2APB_AHB_MAX_DATA_WIDTH-1 : 0] hrdata;
    ahb2apb_ahb_resp                            hresp;

    // Extra Control Signals
    bit                                         is_in_progress;
    bit                                         reseted;
    int unsigned                                length;
    int unsigned                                waiting;
        // When in_progress is asserted then the current inputs
        // are not connected to the current outputs 
        // When in_progress is deasserted then the current inputs
        // are connected to the current outputs
    
    `uvm_object_utils_begin(ahb2apb_ahb_item_mon)
        `uvm_field_int(hsel,      UVM_NOCOMPARE)
        `uvm_field_int(haddr,     UVM_NOCOMPARE)
        `uvm_field_enum(ahb2apb_ahb_trans,htrans,    UVM_NOCOMPARE)
        `uvm_field_enum(ahb2apb_ahb_size,hsize,     UVM_NOCOMPARE)
        `uvm_field_int(hprot,     UVM_NOCOMPARE)
        `uvm_field_enum(ahb2apb_ahb_dir,hwrite,    UVM_NOCOMPARE)
        `uvm_field_int(hready,    UVM_NOCOMPARE)
        `uvm_field_int(hwdata,    UVM_NOCOMPARE)
        `uvm_field_int(hreadyout, UVM_DEFAULT)
        `uvm_field_int(hrdata,    UVM_DEFAULT)
        `uvm_field_enum(ahb2apb_ahb_resp,hresp,     UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "ahb2apb_ahb_item_mon");
        super.new(name);
    endfunction

    virtual function string in2string;
        return $sformatf(
            "HSEL=%0h HADDR=%0h HTRANS=%0h HSIZE=%0h HPROT=%0h HWRITE=%0h HREADY=%0h HWDATA=%0h",
            hsel, haddr, htrans, hsize, hprot, hwrite, hready, hwdata
        );
    endfunction

    virtual function string out2string;
        return $sformatf(
            "HREADYOUT=%0h HRDATA=%0h HRESP=%0h",
            hreadyout, hrdata, hresp
        );
    endfunction

    virtual function string convert2string;
        string str;

        // Append object base info
        str = super.convert2string(); 

        // Format transaction fields cleanly
        str = {str, $sformatf("\n--- [AHB Monitor Item] ---")};
        str = {str, $sformatf("\n-------- [INPUTS] --------")};
        str = {str, $sformatf("\n hsel              : %0b", hsel)};
        str = {str, $sformatf("\n haddr             : %0h", haddr)};
        str = {str, $sformatf("\n htrans            : %0s", htrans.name())};
        str = {str, $sformatf("\n hsize             : %0s", hsize.name())};
        str = {str, $sformatf("\n hwrite            : %0s", hwrite.name())};
        str = {str, $sformatf("\n hprot             : %0h", hprot)};
        str = {str, $sformatf("\n hwdata            : %0h", hwdata)};
        str = {str, $sformatf("\n hready            : %0b", hready)};
        str = {str, $sformatf("\n------- [OUTPUTS] --------")};
        str = {str, $sformatf("\n hrdata            : %0h", hrdata)};
        str = {str, $sformatf("\n hreadyout         : %0b", hreadyout)};
        str = {str, $sformatf("\n hresp             : %0s", hresp.name())};
        str = {str, $sformatf("\n------- [CONTROL] --------")};
        str = {str, $sformatf("\n is_in_progress    : %0b", is_in_progress)};
        str = {str, $sformatf("\n-------- [DELAY] ---------")};
        if (!this.is_in_progress)
            str = {str, $sformatf("\n Latency           : %0d", length)};
        else
            str = {str, $sformatf("\n Item Seperation   : %0d", waiting)};

        return str;
    endfunction

    virtual function void reset_item();
    hsel            = 0;
    haddr           = 0;
    htrans          = IDLE;
    hsize           = BYTE;
    hprot           = 0;
    hwrite          = AHB_WRITE;
    hready          = 0;
    hwdata          = 0;

    hreadyout       = 0;
    hrdata          = 0;
    hresp           = AHB_OKAY ;
    length          = 0;
    waiting         = 0;

    is_in_progress  = 0;
    reseted         = 1;
    endfunction
endclass

`endif