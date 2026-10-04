interface ahb2apb_ahb_if 
#(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 32
)
(
    input HCLK
);

    // Reset signal 
    logic HRESETn;

    // AHB master to  slave signals
    logic HSEL;
    logic [ADDR_WIDTH-1:0] HADDR;
    logic [1:0] HTRANS;
    logic [2:0]  HSIZE;
    logic [3:0]  HPROT;
    logic HWRITE; 
    logic HREADY;     
    logic [DATA_WIDTH-1:0] HWDATA;   

    // AHB slave to master signals
    logic HREADYOUT;
    logic [DATA_WIDTH-1:0] HRDATA;
    logic HRESP; 
  
endinterface