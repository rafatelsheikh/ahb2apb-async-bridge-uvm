`ifndef AHB2APB_TESTBENCH_SV
    `define AHB2APB_TESTBENCH_SV
    
    `include "ahb2apb_ahb_if.sv"
    `include "ahb2apb_apb_if.sv"
    `include "ahb2apb_test_data_type.sv"

    module ahb2apb_testbench ();
        import uvm_pkg::*;
        import ahb2apb_pkg::*;

        // clock generators 
        bit pclk;
        bit hclk;
        always begin
            #10
            pclk = ~pclk;
        end

        always begin
            #10
            hclk = ~hclk;
        end

        //interfaces
        //------------------------
        // AHP if
        ahb2apb_ahb_if #(
            .ADDR_WIDTH(`AHB2APB_AHB_MAX_ADDR_WIDTH),
            .DATA_WIDTH(`AHB2APB_AHB_MAX_DATA_WIDTH) 
        ) ahb_if (hclk);
        
        // APB if
        ahb2apb_apb_if #(
            .ADDR_WIDTH(`AHB2APB_APB_MAX_ADDR_WIDTH),
            .DATA_WIDTH(`AHB2APB_APB_MAX_DATA_WIDTH) 
        ) apb_if (pclk);
        //------------------------

        //DUT
        cmsdk_ahb_to_apb_async #(.ADDRWIDTH(`AHB2APB_AHB_MAX_ADDR_WIDTH)) 
        DUT (
            // clocks
            .HCLK (hclk),
            .PCLK (pclk),
            // resets
            .HRESETn (ahb_if.HRESETn),
            .PRESETn (apb_if.PRESETn),
            // AHB side
            .HSEL (ahb_if.HSEL),
            .HADDR (ahb_if.HADDR),
            .HTRANS (ahb_if.HTRANS),
            .HSIZE (ahb_if.HSIZE),
            .HPROT (ahb_if.HPROT),
            .HWRITE (ahb_if.HWRITE),
            .HREADY (ahb_if.HREADY),
            .HWDATA (ahb_if.HWDATA),
            .HREADYOUT (ahb_if.HREADYOUT),
            .HRDATA (ahb_if.HRDATA),
            .HRESP (ahb_if.HRESP),
            // APB side
            .APBACTIVE (apb_if.APBACTIVE),
            .PSEL (apb_if.PSEL),
            .PADDR (apb_if.PADDR),
            .PENABLE (apb_if.PENABLE),
            .PSTRB (apb_if.PSTRB),
            .PPROT (apb_if.PPROT),
            .PWRITE (apb_if.PWRITE),
            .PWDATA (apb_if.PWDATA),
            .PREADY (apb_if.PREADY),
            .PSLVERR (apb_if.PSLVERR),
            .PRDATA (apb_if.PRDATA)
        );

        // connect HREADY with HREADYOUT as we have only one master and one slave
        assign ahb_if.HREADY = ahb_if.HREADYOUT;

        // run test
        initial begin
            uvm_config_db #(virtual ahb2apb_ahb_if)::set(null, "uvm_test_top", "AHB_IF", ahb_if);
            uvm_config_db #(virtual ahb2apb_apb_if)::set(null, "uvm_test_top", "APB_IF", apb_if);
            run_test("ahb2apb_test_simple");
        end

        // reset at the start of the test
        initial begin
            ahb_if.HRESETn = 0;
            apb_if.PRESETn = 0;
            #(20ns);
            ahb_if.HRESETn = 1;
            apb_if.PRESETn = 1;
        end

        bind cmsdk_ahb_to_apb_async ahb2apb_ahb_assertions bridge_ahb_assert (.*);
        bind cmsdk_ahb_to_apb_async ahb2apb_apb_assertions bridge_apb_assert (.*);

    endmodule

`endif 