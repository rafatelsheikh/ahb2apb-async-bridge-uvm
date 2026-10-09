`ifndef AHB2APB_APB_ASSERTIONS_SV
    `define AHB2APB_APB_ASSERTIONS_SV

    `include "ahb2apb_apb_assertions_macros.sv"

    module ahb2apb_apb_assertions (
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
        input [31:0] PRDATA 
    );
        // label A: for assert & C: for cover

        always_comb begin
            ERR_undefined_reset_signal_A: assert final(!$isunknown(PRESETn));
            ERR_undefined_reset_signal_C: cover final(!$isunknown(PRESETn));
            
            ERR_undefined_clk_gate_en_signal_A: assert final(!$isunknown(APBACTIVE));
            ERR_undefined_clk_gate_en_signal_C: cover final(!$isunknown(APBACTIVE));

            if(!PRESETn) begin
                ERR_reset_functionality_A: assert final(PSEL == 0 && PENABLE == 0 && PADDR== 0 && PWRITE == 0 && 
                                                        PPROT == 0 && PSTRB == 0 && PWDATA == 0 && APBACTIVE == 0);
                ERR_reset_functionality_C: cover final(PSEL == 0 && PENABLE == 0 && PADDR== 0 && PWRITE == 0 && 
                                                        PPROT == 0 && PSTRB == 0 && PWDATA == 0 && APBACTIVE == 0);	  
            end
        end 

        ERR_PSEL_is_unknown_A: `assert_clk (!$isunknown(PSEL));
        ERR_PSEL_is_unknown_C: `cover_assert_clk (!$isunknown(PSEL));

        ERR_PENABLE_is_unknown_A: `assert_clk (!$isunknown(PENABLE));
        ERR_PENABLE_is_unknown_C: `cover_assert_clk (!$isunknown(PENABLE));

        ERR_PADDR_is_unknown_A: `assert_clk (!$isunknown(PADDR));
        ERR_PADDR_is_unknown_C: `cover_assert_clk (!$isunknown(PADDR));

        ERR_PWRITE_is_unknown_A: `assert_clk (!$isunknown(PWRITE));
        ERR_PWRITE_is_unknown_C: `cover_assert_clk (!$isunknown(PWRITE));

        ERR_PPROT_is_unknown_A: `assert_clk (!$isunknown(PPROT));
        ERR_PPROT_is_unknown_C: `cover_assert_clk (!$isunknown(PPROT));

        ERR_PSTRB_is_unknown_A: `assert_clk (!$isunknown(PSTRB));
        ERR_PSTRB_is_unknown_C: `cover_assert_clk (!$isunknown(PSTRB));

        ERR_PWDATA_is_unknown_A: `assert_clk (!$isunknown(PWDATA));
        ERR_PWDATA_is_unknown_C: `cover_assert_clk (!$isunknown(PWDATA));

        ERR_PREADY_is_unknown_A: `assert_clk (!$isunknown(PREADY));
        ERR_PREADY_is_unknown_C: `cover_assert_clk (!$isunknown(PREADY));

        ERR_PSLVERR_is_unknown_A: `assert_clk (!$isunknown(PSLVERR));
        ERR_PSLVERR_is_unknown_C: `cover_assert_clk (!$isunknown(PSLVERR));

        ERR_PRDATA_is_unknown_A: `assert_clk (!$isunknown(PRDATA));
        ERR_PRDATA_is_unknown_C: `cover_assert_clk (!$isunknown(PRDATA));

        ERR_PENABLE_seq_is_wrong_A: `assert_clk (PSEL |-> !PENABLE |=> PENABLE);
        ERR_PENABLE_seq_is_wrong_C: `cover_assert_clk (PSEL |-> !PENABLE |=> PENABLE);

        ERR_PSEL_is_deasserted_while_PENABLE_asserted_A: `assert_clk ($rose(PENABLE) |-> PSEL);
        ERR_PSEL_is_deasserted_while_PENABLE_asserted_C: `cover_assert_clk ($rose(PENABLE) |-> PSEL);

        ERR_PENABLE_held_until_PREADY_A: `assert_clk ($rose(PENABLE) |-> (PENABLE throughout (PREADY[->1])));
        ERR_PENABLE_held_until_PREADY_C: `cover_assert_clk ($rose(PENABLE) |-> (PENABLE throughout (PREADY[->1])));

        ERR_PADDR_unstable_while_transaction_A: `assert_clk ((PSEL && !PENABLE) |=> ($stable(PADDR)throughout((PENABLE && PREADY)[->1])));
        ERR_PADDR_unstable_while_transaction_C: `cover_assert_clk ((PSEL && !PENABLE) |=> ($stable(PADDR)throughout((PENABLE && PREADY)[->1])));

        ERR_PWDATA_unstable_while_transaction_A: `assert_clk ((PSEL && !PENABLE) |=> ($stable(PWDATA)throughout((PENABLE && PREADY)[->1])));
        ERR_PWDATA_unstable_while_transaction_C: `cover_assert_clk ((PSEL && !PENABLE) |=> ($stable(PWDATA)throughout((PENABLE && PREADY)[->1])));

        ERR_PWRITE_unstable_while_transaction_A: `assert_clk ((PSEL && !PENABLE) |=> ($stable(PWRITE)throughout((PENABLE && PREADY)[->1])));
        ERR_PWRITE_unstable_while_transaction_C: `cover_assert_clk ((PSEL && !PENABLE) |=> ($stable(PWRITE)throughout((PENABLE && PREADY)[->1])));

        ERR_PSTRB_unstable_while_transaction_A: `assert_clk ((PSEL && !PENABLE) |=> ($stable(PSTRB)throughout((PENABLE && PREADY)[->1])));
        ERR_PSTRB_unstable_while_transaction_C: `cover_assert_clk ((PSEL && !PENABLE) |=> ($stable(PSTRB)throughout((PENABLE && PREADY)[->1])));

        ERR_PPROT_unstable_while_transaction_A: `assert_clk ((PSEL && !PENABLE) |=> ($stable(PPROT)throughout((PENABLE && PREADY)[->1])));
        ERR_PPROT_unstable_while_transaction_C: `cover_assert_clk ((PSEL && !PENABLE) |=> ($stable(PPROT)throughout((PENABLE && PREADY)[->1])));

        ERR_PREADY_asserted_in_wrong_phase_A: `assert_clk ($rose(PREADY) |-> (PENABLE && PSEL));
        ERR_PREADY_asserted_in_wrong_phase_C: `cover_assert_clk ($rose(PREADY) |-> (PENABLE && PSEL));

        ERR_PPROT1_not_constant_A: `assert_clk ($stable(PPROT[1]));
        ERR_PPROT1_not_constant_C: `cover_assert_clk ($stable(PPROT[1]));

        
    endmodule

`endif 