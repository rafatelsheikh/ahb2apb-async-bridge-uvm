`ifndef AHB2APB_TEST_SHIFT_CLK_SV
    `define AHB2APB_TEST_SHIFT_CLK_SV

    class ahb2apb_test_shift_clk extends ahb2apb_test_parameterized_clk #(.ahb_clk(10.0), .apb_clk(10.0), .phase_shift_180(1));
        `uvm_component_utils(ahb2apb_test_shift_clk)

        // contructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass

`endif