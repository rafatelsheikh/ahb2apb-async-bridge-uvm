`ifndef AHB2APB_ASSERTIONS_SV
    `define AHB2APB_ASSERTIONS_SV

    `include "ahb2apb_assertions_macros.sv"

    module ahb2apb_assertions (
        // APB signals
        input APBACTIVE,
        input PCLK,
        input PRESETn,
        input PSEL,
        input PENABLE,
        input [15:0] PADDR,
        input PWRITE,
        input [2:0] PPROT,
        input [3:0] PSTRB,
        input [31:0] PWDATA,
        input PREADY,
        input PSLVERR,
        input [31:0] PRDATA,
        
        // AHB signals
        input logic HCLK,
        input logic HRESETn,
        input logic HSEL,
        input logic [`AHB2APB_AHB_MAX_ADDR_WIDTH-1:0] HADDR,
        input logic [1:0] HTRANS,
        input logic [2:0] HSIZE,
        input logic [3:0] HPROT,
        input logic HWRITE,
        input logic HREADY,
        input logic [`AHB2APB_AHB_MAX_DATA_WIDTH-1:0] HWDATA,
        input logic HREADYOUT,
        input logic HRESP,
        input logic [`AHB2APB_AHB_MAX_DATA_WIDTH-1:0] HRDATA 
    );
        // indicate the end and start of the transfer
        wire ahb_start;
        wire apb_done;
        assign ahb_start = (HSEL && HTRANS[1] && HREADY);
        assign apb_done = (PREADY && PENABLE && PSEL);

        // Cover label for covering the assertions
        
        // Check clock is valid signal
        always_comb begin
            // HCLK
            ERR_HCLK_is_unknown_signal: 
                assert final(!$isunknown(HCLK));
            ERR_HCLK_is_unknown_signal_cover: 
                cover final(!$isunknown(HCLK));
            // PCLK
            ERR_PCLK_is_unknown_signal:
                assert final(!$isunknown(PCLK));
            ERR_PCLK_is_unknown_signal_cover:
                cover final(!$isunknown(PCLK));
        end

        
        ERR_the_end_tranfer_operation_not_converted_into_HREADYOUT: 
            `assert_both_clk (apb_done |=> HREADYOUT[->1]);
        ERR_the_end_tranfer_operation_not_converted_into_HREADYOUT_cover: 
            `cover_both_clk (apb_done |=> HREADYOUT[->1]);

        ERR_start_of_transfer_operation_not_converted_into_PSEL:
            `assert_both_clk (ahb_start |=> PSEL[->1]);
        ERR_start_of_transfer_operation_not_converted_into_PSEL_cover:
            `cover_both_clk (ahb_start |=> PSEL[->1]);
        
        ERR_start_of_transfer_operation_not_enable_clk_gate:
            `assert_both_clk (ahb_start |=> APBACTIVE[->1]);
        ERR_start_of_transfer_operation_not_enable_clk_gate_cover:
            `cover_both_clk (ahb_start |=> APBACTIVE[->1]);

        ERR_end_of_transfer_operation_not_disable_clk_gate:
            `assert_pclk (apb_done |=> !APBACTIVE);
        ERR_end_of_transfer_operation_not_disable_clk_gate_cover:
            `cover_pclk (apb_done |=> !APBACTIVE);

        ERR_the_error_response_not_converted_into_HRESP:
            `assert_both_clk (PSLVERR |=> HRESP[->1]);
        ERR_the_error_response_not_converted_into_HRESP_cover:
            `cover_both_clk (PSLVERR |=> HRESP[->1]);

        ERR_HREADYOUT_not_seasserted_at_start_of_transfer:
            `assert_hclk (ahb_start |=> !HREADYOUT);
        ERR_HREADYOUT_not_seasserted_at_start_of_transfer_cover:
            `cover_hclk (ahb_start |=> !HREADYOUT);
        
    endmodule

`endif 