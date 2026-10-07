`ifndef AHB2APB_AHB_TYPES_SV
    `define AHB2APB_AHB_TYPES_SV

    // Type definitions 

    // Virtual interface
    typedef virtual ahb2apb_ahb_if ahb2apb_ahb_vif;

    // AHB operation direction
    typedef enum bit {
        AHB_WRITE = 1'b1, 
        AHB_READ = 1'b0
    } ahb2apb_ahb_dir;

    // AHB transfer type
    typedef enum bit [1:0] {
        IDLE   = 2'b00,
        BUSY   = 2'b01,
        NONSEQ = 2'b10,
        SEQ    = 2'b11
    } ahb2apb_ahb_trans;
    
    // AHB size type
    typedef enum bit [2:0] {
        BYTE      = 3'b000,
        HALF_WORD = 3'b001,
        WORD      = 3'b010
    } ahb2apb_ahb_size;

    // AHB Response
    typedef enum bit { 
        AHB_OKAY  = 1'b0, 
        AHB_ERROR = 1'b1
    } ahb2apb_ahb_resp;

    // AHB address
    typedef bit [`AHB2APB_AHB_MAX_ADDR_WIDTH-1:0] ahb2apb_ahb_addr;
    // AHB DATA
    typedef bit [`AHB2APB_AHB_MAX_DATA_WIDTH-1:0] ahb2apb_ahb_data;
    
`endif