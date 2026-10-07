`ifndef AHB2APB_TEST_DATA_TYPE_SV
    `define AHB2APB_TEST_DATA_TYPE_SV

    // AHB macros
    `ifndef AHB2APB_AHB_MAX_ADDR_WIDTH
        `define AHB2APB_AHB_MAX_ADDR_WIDTH 16
    `endif 
    `ifndef AHB2APB_AHB_MAX_DATA_WIDTH
    `define AHB2APB_AHB_MAX_DATA_WIDTH 32
    `endif 

    // APB macros
    `ifndef AHB2APB_APB_MAX_ADDR_WIDTH
        `define AHB2APB_APB_MAX_ADDR_WIDTH 16
    `endif 
    `ifndef AHB2APB_APB_MAX_DATA_WIDTH
        `define AHB2APB_APB_MAX_DATA_WIDTH 32
    `endif 
    
`endif