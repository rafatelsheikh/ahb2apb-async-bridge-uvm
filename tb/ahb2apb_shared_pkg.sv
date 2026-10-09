`ifndef AHB2APB_SHARED_PKG_SV
    `define AHB2APB_SHARED_PKG_SV

    `include "uvm_macros.svh"

    package ahb2apb_shared_pkg;
        import uvm_pkg::*;

        `include "ahb2apb_reset_handler.sv"
    endpackage

`endif