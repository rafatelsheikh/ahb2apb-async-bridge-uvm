`ifndef AHB2APB_TEST_PARAMETERIZED_CLK_SV
    `define AHB2APB_TEST_PARAMETERIZED_CLK_SV

    class ahb2apb_test_parameterized_clk #(real ahb_clk = 10.0, real apb_clk = 10.0, bit phase_shift_180 = 0) extends ahb2apb_test_main;
        `uvm_component_param_utils(ahb2apb_test_parameterized_clk #(ahb_clk, apb_clk, phase_shift_180))

        // clock config handle
        ahb2apb_clock_config clk_cfg;

        // constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        // build phase
        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            clk_cfg = ahb2apb_clock_config::type_id::create("clk_cfg");

            clk_cfg.ahb_clk = ahb_clk;
            clk_cfg.apb_clk = apb_clk;
            clk_cfg.phase_shift_180 = phase_shift_180;

            uvm_config_db#(ahb2apb_clock_config)::set(this, "", "CLK_CFG", clk_cfg);
        endfunction
    endclass

`endif