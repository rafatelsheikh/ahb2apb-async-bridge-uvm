`ifndef AHB2APB_TEST_DOUBLE_CLK_SV
    `define AHB2APB_TEST_DOUBLE_CLK_SV

    class ahb2apb_test_double_clk extends ahb2apb_test_parameterized_clk #(.ahb_clk(5.0), .apb_clk(10.0), .phase_shift_180(0));
        `uvm_component_utils(ahb2apb_test_double_clk)

        // contructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass

`endif