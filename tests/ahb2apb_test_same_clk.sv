`ifndef AHB2APB_TEST_SAME_CLK_SV
    `define AHB2APB_TEST_SAME_CLK_SV

    class ahb2apb_test_same_clk extends ahb2apb_test_parameterized_clk #(.ahb_clk(10.0), .apb_clk(10.0), .phase_shift_180(0));
        `uvm_component_utils(ahb2apb_test_same_clk)

        // contructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass

`endif