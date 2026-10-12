`ifndef AHB2APB_CLOCK_CONFIG_SV
    `define AHB2APB_CLOCK_CONFIG_SV

    class ahb2apb_clock_config extends uvm_object;
        `uvm_object_utils(ahb2apb_clock_config)
        
        // variables
        real ahb_clk;
        real apb_clk;
        bit phase_shift_180;

        // constructor
        function new(string name = "ahb2apb_clock_config");
            super.new(name);

            ahb_clk = 10.0;
            apb_clk = 10.0;
        endfunction
    endclass

`endif