`ifndef AHB2APB_APB_ASSERTIONS_MACROS_SV
    `define AHB2APB_APB_ASSERTIONS_MACROS_SV

    // the APB assertion with posedge clk and disabled when the reset is asserted
    `ifndef assert_clk
        `define assert_clk(arg) \
            assert property (@(posedge PCLK) disable iff (!PRESETn) arg)
    `endif

    // the APB assertion with posedge clk and not dependent on reset
    `ifndef assert_async
        `define assert_async(arg) \
            assert property (@(posedge PCLK) arg)
    `endif

    // the APB cover assertion with posedge clk and disabled when the reset is asserted
    `ifndef cover_assert_clk
        `define cover_assert_clk(arg) \
            cover property (@(posedge PCLK) disable iff (!PRESETn) arg)
    `endif

    // the APB cover assertion with posedge clk and not dependent on reset
    `ifndef cover_assert_async
        `define cover_assert_async(arg) \
            cover property (@(posedge PCLK) arg)
    `endif

`endif