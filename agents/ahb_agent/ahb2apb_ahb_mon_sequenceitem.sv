`ifndef AHB2APB_AHB_MON_SEQUENCEITEM_SV
    `define AHB2APB_AHB_MON_SEQUENCEITEM_SV

/****************************************************
*This File represents the Sequence item that will be* 
*used in AHB_Monitor and then sent through the      *
*analysis port to scoreboard and coverage           *
******************************************************/
class ahb2apb_ahb_mon_sequenceitem extends uvm_sequence_item
#(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 32
);
    // ahb signals
    // Input Signals
    bit                         HSEL;
    logic   [ADDR_WIDTH-1 : 0]  HADDR;
    ahb2apb_ahb_trans           HTRANS;
    ahb2apb_ahb_size            HSIZE;
    logic   [3:0]               HPROT;
    ahb2apb_ahb_dir             HWRITE;
    bit                         HREADY;
    logic   [DATA_WIDTH-1 : 0]  HWDATA;
    // Output Signals
    logic                       HREADYOUT;
    logic   [DATA_WIDTH-1 : 0]  HRDATA;
    logic                       HRESP;
    // Extra Control Signals
    bit                         in_progress;
        // When in_progress is asserted then the current inputs
        // are not connected to the current outputs 
        // When in_progress is deasserted then the current inputs
        // are connected to the current outputs
    
    `uvm_object_utils_begin (ahb2apb_ahb_mon_sequenceitem)
        `uvm_field_int (HSEL,UVM_DEFAULT)
        `uvm_field_int (HADDR,UVM_DEFAULT)
        `uvm_field_int (HTRANS,UVM_DEFAULT)
        `uvm_field_int (HSIZE,UVM_DEFAULT)
        `uvm_field_int (HPROT,UVM_DEFAULT)
        `uvm_field_int (HWDATA,UVM_DEFAULT)
        `uvm_field_int (HREADY,UVM_DEFAULT)
        `uvm_field_int (HWDATA,UVM_DEFAULT)
        `uvm_field_int (HREADYOUT,UVM_DEFAULT)
        `uvm_field_int (HRDATA,UVM_DEFAULT)
        `uvm_field_int (HRESP,UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "ahb2apb_ahb_mon_sequenceitem");
        super.new(name);
        `uvm_info(get_type_name(), "Built Sucesfully,UVM_LOW",UVM_LOW)
    endfunction
endclass