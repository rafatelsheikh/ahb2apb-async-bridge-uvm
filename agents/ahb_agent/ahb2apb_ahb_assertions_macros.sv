`ifndef AHB2APB_AHB_ASSERTIONS_MACROS_SV
    `define AHB2APB_AHB_ASSERTIONS_MACROS_SV

    // the ahb assertion with posedge clk and disabled when the reset is asserted
    `ifndef assert_hclk
        `define assert_hclk(arg) \
            assert property (@(posedge HCLK) disable iff (!HRESETn) arg)
    `endif

    // the ahb assertion with posedge clk and not disabled when the reset is asserted
    `ifndef assert_async_hrst
        `define assert_async_hrst(arg) \
            assert property (@(posedge HCLK) arg)
    `endif

`endif