`ifndef AHB2APB_ASSERTIONS_MACROS_SV
    `define AHB2APB_ASSERTIONS_MACROS_SV

    // Assertion with both clocks and disabled with both resets
    `ifndef assert_both_clk
        `define assert_both_clk(arg) \
            assert property (@(posedge HCLK or posedge PCLK) disable iff (!HRESETn || !PRESETn) arg)
    `endif

    // cover with both clocks and disabled with both resets
    `ifndef cover_both_clk
        `define cover_both_clk(arg) \
            cover property (@(posedge HCLK or posedge PCLK) disable iff (!HRESETn || !PRESETn) arg)
    `endif

    // Assertion with the PCLK and disabled with PRESETn
    `ifndef assert_pclk
        `define assert_pclk(arg) \
            assert property (@(posedge PCLK) disable iff (!PRESETn) arg)
    `endif

    // cover with the PCLK and disabled with PRESETn
    `ifndef cover_pclk
        `define cover_pclk(arg) \
            cover property (@(posedge PCLK) disable iff (!PRESETn) arg)
    `endif

    // Assertion with the HCLK and disabled with HRESETn
    `ifndef assert_hclk
        `define assert_hclk(arg) \
            assert property (@(posedge HCLK) disable iff (!HRESETn) arg)
    `endif

    // cover with the HCLK and disabled with HRESETn
    `ifndef cover_hclk
        `define cover_hclk(arg) \
            cover property (@(posedge HCLK) disable iff (!HRESETn) arg)
    `endif

`endif