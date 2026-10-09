`ifndef AHB2APB_AHB_ASSERTIONS_SV
    `define AHB2APB_AHB_ASSERTIONS_SV

    `include "ahb2apb_ahb_assertions_macros.sv"

    module ahb2apb_ahb_assertions (
        // master signals
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

        // slave signals
        input logic HREADYOUT,
        input logic HRESP,
        input logic [`AHB2APB_AHB_MAX_DATA_WIDTH-1:0] HRDATA
    );
        // immediate assertions for reset related checks
        always_comb begin
            if ($time > 0) begin
                ERR_UNKNOWN_VALUE_FOR_HRESETn:
                    assert final (!$isunknown(HRESETn)); 
            end

            if (!HRESETn) begin
                ERR_HREADYOUT_IS_NOT_HIGH_DURING_RESET:
                    assert final (HREADYOUT === 1'b1); 

                ERR_HRESP_IS_NOT_OKAY_DURING_RESET:
                    assert final (HRESP === 1'b0);

                ERR_HTRANS_IS_NOT_IDLE_DURING_RESET:
                    assert final (HTRANS === 2'b00);  
            end
        end

        // signals that should be valid all the time
        ERR_UNKNOWN_VALUE_FOR_HSEL:
            `assert_hclk (!$isunknown(HSEL));

        ERR_UNKNOWN_VALUE_FOR_HTRANS:
            `assert_hclk (!$isunknown(HTRANS));

        ERR_UNKNOWN_VALUE_FOR_HADDR:
            `assert_hclk (!$isunknown(HADDR));

        ERR_UNKNOWN_VALUE_FOR_HREADY:
            `assert_hclk (!$isunknown(HREADY));

        ERR_UNKNOWN_VALUE_FOR_HREADYOUT:
            `assert_hclk (!$isunknown(HREADYOUT));

        ERR_UNKNOWN_VALUE_FOR_HRESP:
            `assert_hclk (!$isunknown(HRESP));

        // signals that should be valid when HTRANS is not IDLE
        ERR_UNKNOWN_VALUE_FOR_HPROT_WHILE_HTRANS_IS_NOT_IDLE:
            `assert_hclk ((HTRANS !== 2'b00) |-> (!$isunknown(HPROT)));

        ERR_UNKNOWN_VALUE_FOR_HSIZE_WHILE_HTRANS_IS_NOT_IDLE:
            `assert_hclk ((HTRANS !== 2'b00) |-> (!$isunknown(HSIZE)));

        ERR_UNKNOWN_VALUE_FOR_HWRITE_WHILE_HTRANS_IS_NOT_IDLE:
            `assert_hclk ((HTRANS !== 2'b00) |-> (!$isunknown(HWRITE)));

        // signals that should be valid during the data phase for a write operateion
        ERR_UNKNOWN_VALUE_FOR_HWDATA_WHILE_IN_DATA_PHASE_FOR_A_WRITE_OPERATION:
            `assert_hclk ((HWRITE && HREADY && (HTRANS == 2'b10 || HTRANS == 2'b11)) |->
                ##1 ((!$isunknown(HWDATA))throughout (HREADY[->1])));

        // signals that should be valid during the last cycle in the data phase for an okay read operateion
        ERR_UNKNOWN_VALUE_FOR_HRDATA_WHILE_IN_DATA_PHASE_FOR_AN_OKAY_READ_OPERATION:
            `assert_hclk ((!HWRITE && HREADY && (HTRANS == 2'b10 || HTRANS == 2'b11)) |->
                ##1 (HREADY[->1] ##0 (!$isunknown(HRDATA) || HRESP)));

        // error response rules
        ERR_INVALID_TWO_CYCLE_ERROR_RESPONSE:
            `assert_hclk ($rose(HRESP) |-> (!HREADYOUT) ##1 $rose(HREADYOUT) ##1 $fell(HRESP));

        // signals stability rules
        ERR_HADDR_IS_NOT_STABLE_DURING_THE_ADDRESS_PHASE:
            `assert_hclk (((HTRANS == 2'b10 || HTRANS == 2'b11) && !HREADY) |-> ##1 $stable(HADDR));

        ERR_HTRANS_IS_NOT_STABLE_DURING_THE_ADDRESS_PHASE:
            `assert_hclk (((HTRANS == 2'b10 || HTRANS == 2'b11) && !HREADY) |-> ##1 $stable(HTRANS));

        ERR_HSIZE_IS_NOT_STABLE_DURING_THE_ADDRESS_PHASE:
            `assert_hclk (((HTRANS == 2'b10 || HTRANS == 2'b11) && !HREADY) |-> ##1 $stable(HSIZE));

        ERR_HWRITE_IS_NOT_STABLE_DURING_THE_ADDRESS_PHASE:
            `assert_hclk (((HTRANS == 2'b10 || HTRANS == 2'b11) && !HREADY) |-> ##1 $stable(HWRITE));

        ERR_HWDATA_IS_NOT_STABLE_DURING_THE_DATA_PHASE_OF_A_WRITE_OPERATION:
            `assert_hclk ((HWRITE && HREADY && (HTRANS == 2'b10 || HTRANS == 2'b11)) ##1 !HREADY |->
                ##1 (($stable(HWDATA)) throughout (HREADY[->1])));
    endmodule

`endif