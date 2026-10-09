`ifndef AHB2APB_RESET_HANDLER_SV
    `define AHB2APB_RESET_HANDLER_SV

    // reset handler class is to ensure that every class that
    // implements it, should implement the function handle reset
    interface class ahb2apb_reset_handler;
        pure virtual function void handle_reset(uvm_phase phase);
    endclass

`endif