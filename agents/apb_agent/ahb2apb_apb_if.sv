`ifndef AHB2APB_APB_IF_SV
    `define AHB2APB_APB_IF_SV

    interface ahb2apb_apb_if #(
        parameter ADDR_WIDTH = 16,
        parameter DATA_WIDTH = 32
    ) (
        input logic PCLK
    );
        // bridge related signals
        logic APBACTIVE;
        logic PRESETn;

        // apb master to slave signals
        logic PSEL;
        logic [ADDR_WIDTH-1:0] PADDR;
        logic PENABLE;
        logic [(DATA_WIDTH/8)-1:0] PSTRB;
        logic [2:0] PPROT;
        logic PWRITE;
        logic [DATA_WIDTH-1:0] PWDATA;

        // apb slave to master signals
        logic PREADY;
        logic PSLVERR;
        logic [DATA_WIDTH-1:0] PRDATA;
    endinterface

`endif