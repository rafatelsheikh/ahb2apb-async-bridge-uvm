`ifndef AHB2APB_APB_COVERAGE_SV
    `define AHB2APB_APB_COVERAGE_SV

    class ahb2apb_apb_coverage extends uvm_subscriber #(ahb2apb_apb_item_mon);
        `uvm_component_utils(ahb2apb_apb_coverage)

        // coverage group sampling the apb item
        covergroup apb_cover_item with function sample(ahb2apb_apb_item_mon item);
            option.per_instance = 1;

            // covering pstrb[3:0] signal during write operations only, as it's 
            // deactivated during read operations, to make sure all the byte lanes are covered
            // according to the legal combinations of hsize and haddr[1:0] signals
            // of the ahb item during and make sure any other combination is illegal
            cp_pstrb: coverpoint item.pstrb iff (item.pwrite) {
                bins pstrb_byte_0_offset = {4'b0001};
                bins pstrb_byte_1_offset = {4'b0010};
                bins pstrb_byte_2_offset = {4'b0100};
                bins pstrb_byte_3_offset = {4'b1000};
                bins pstrb_half_word_0_offset = {4'b0011};
                bins pstrb_half_word_2_offset = {4'b1100};
                bins pstrb_word_0_offset = {4'b1111};
                illegal_bins pstrb_illegal = default;
            }

            // covering pprot[2] and pprot[0] signals only, as pprot[1] is always 0
            cp_pprot: coverpoint {item.pprot[2], item.pprot[0]} {
                bins data_user = {2'b00};
                bins data_privileged = {2'b01};
                bins opcode_user = {2'b10};
                bins opcode_privileged = {2'b11};
            }

            // covering paddr[1:0] signal to make sure it's always 0
            cp_paddr: coverpoint item.paddr[1:0] {
                bins paddr_legal = {2'b00};
                illegal_bins paddr_illegal = default;
            }

            // covering pwrite signal
            cp_pwrite: coverpoint item.pwrite {
                bins pwrite_read = {1'b0};
                bins pwrite_write = {1'b1};
            }

            // covering pwrite transitions to make sure there are transitions
            // from read to read, read to write, write to read and write to write
            cp_pwrite_transitions: coverpoint item.pwrite {
                bins pwrite_read_to_read = (1'b0 => 1'b0);
                bins pwrite_read_to_write = (1'b0 => 1'b1);
                bins pwrite_write_to_read = (1'b1 => 1'b0);
                bins pwrite_write_to_write = (1'b1 => 1'b1);
            }

            // covering pslverr signal
            cp_pslverr: coverpoint item.pslverr {
                bins pslverr_okay = {1'b0};
                bins pslverr_error = {1'b1};
            }

            // covering pslverr transitions to make sure there are transitions
            // from okay to okay, okay to error, error to okay and error to error
            cp_pslverr_transitions: coverpoint item.pslverr {
                bins pslverr_okay_to_okay = (1'b0 => 1'b0);
                bins pslverr_okay_to_error = (1'b0 => 1'b1);
                bins pslverr_error_to_okay = (1'b1 => 1'b0);
                bins pslverr_error_to_error = (1'b1 => 1'b1);
            }

            // cross coverage between pwrite and pprot[2:0] to make sure all protection types
            // are covered for both read and write operations
            cp_pwrite_pprot_cross: cross cp_pwrite, cp_pprot;

            // cross coverage between pwrite and pslverr to make sure all the response types
            // are covered for both read and write operations
            cp_pwrite_pslverr_cross: cross cp_pwrite, cp_pslverr;
        endgroup

        // constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);

            apb_cover_item = new();
        endfunction

        // write the coverage item to the coverage group ignoring the items which are in progress
        // as they don't have all the signals of a transfer
        virtual function void write(ahb2apb_apb_item_mon t);
            if (!t.is_in_progress) begin
                apb_cover_item.sample(t);
            end
        endfunction
    endclass

`endif