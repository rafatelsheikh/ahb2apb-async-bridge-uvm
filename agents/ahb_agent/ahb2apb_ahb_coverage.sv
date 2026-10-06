`ifndef AHB2APB_AHB_COVERAGE_SV
    `define AHB2APB_AHB_COVERAGE_SV

    class ahb2apb_ahb_coverage extends uvm_subscriber #(ahb2apb_ahb_item_mon);
        `uvm_component_utils(ahb2apb_ahb_coverage)

        // coverage group sampling the ahb item and ignoring all the items signals
        // when htrans is IDLE except for htrans signal itself, as the other signals
        // are not valid or used in this state
        covergroup ahb_cover_item with function sample(ahb2apb_ahb_item_mon item);
            option.per_instance = 1;

            // covering haddr[1:0] signal to make sure all the offset combinations are covered
            cp_haddr_offset: coverpoint item.haddr[1:0] iff (item.htrans != IDLE) {
                bins haddr_offset_0 = {2'b00};
                bins haddr_offset_1 = {2'b01};
                bins haddr_offset_2 = {2'b10};
                bins haddr_offset_3 = {2'b11};
            }

            // covering htrans signal to make sure that busy and seq states are illegal
            cp_htrans: coverpoint item.htrans {
                bins htrans_idle = {IDLE};
                bins htrans_nonseq = {NONSEQ};
                illegal_bins htrans_busy = {BUSY};
                illegal_bins htrans_seq = {SEQ};
            }

            // covering htrans transitions to make sure all legal states transitions are covered
            cp_htrans_transition: coverpoint item.htrans {
                bins htrans_idle_to_idle = (IDLE => IDLE);
                bins htrans_idle_to_nonseq = (IDLE => NONSEQ);
                bins htrans_nonseq_to_idle = (NONSEQ => IDLE);
                bins htrans_nonseq_to_nonseq = (NONSEQ => NONSEQ);
            }

            // covering hsize signal, it' not needed to cover illegal sizes
            // because the enum data type will not allow illegal sizes to be generated
            cp_hsize: coverpoint item.hsize iff (item.htrans != IDLE);

            // covering hprot[1:0] signal because hprot[3:2] are not used
            cp_hprot: coverpoint item.hprot[1:0] iff (item.htrans != IDLE) {
                bins user_opcode = {2'b00};
                bins user_data = {2'b01};
                bins privileged_opcode = {2'b10};
                bins privileged_data = {2'b11};
            }

            // covering hwrite signal
            cp_hwrite: coverpoint item.hwrite iff (item.htrans != IDLE);

            // covering hwrite transitions to make sure there are transitions
            // from read to read, read to write, write to read and write to write 
            cp_hwrite_transition: coverpoint item.hwrite iff (item.htrans != IDLE) {
                bins hwrite_read_to_read = (AHB_READ => AHB_READ);
                bins hwrite_read_to_write = (AHB_READ => AHB_WRITE);
                bins hwrite_write_to_read = (AHB_WRITE => AHB_READ);
                bins hwrite_write_to_write = (AHB_WRITE => AHB_WRITE);
            }

            // covering hresp signal
            cp_hresp: coverpoint item.hresp iff (item.htrans != IDLE);

            // covering hresp transitions to make sure there are transitions
            // from okay to okay, okay to error, error to okay and error to error
            cp_hresp_transition: coverpoint item.hresp iff (item.htrans != IDLE) {
                bins hresp_okay_to_okay = (AHB_OKAY => AHB_OKAY);
                bins hresp_okay_to_error = (AHB_OKAY => AHB_ERROR);
                bins hresp_error_to_okay = (AHB_ERROR => AHB_OKAY);
                bins hresp_error_to_error = (AHB_ERROR => AHB_ERROR);
            }

            // cross coverage between hwrite, haddr[1:0] and hsize to make sure
            // all the illegal combinations of haddr[1:0] and hsize are ignored
            cp_hwrite_haddr_hsize_cross: cross cp_hwrite, cp_haddr_offset, cp_hsize {
                ignore_bins unaligned_half_word = binsof(cp_haddr_offset) intersect {2'b01, 2'b11} &&
                                                    binsof(cp_hsize) intersect {HALF_WORD};
                ignore_bins unaligned_word = binsof(cp_haddr_offset) intersect {2'b01, 2'b10, 2'b11} &&
                                                    binsof(cp_hsize) intersect {WORD};
            }

            // cross coverage between hwrite signal and hprot[1:0] to make sure
            // all the protection types are covered for both read and write operations
            cp_hwrite_hprot_cross: cross cp_hwrite, cp_hprot;

            // cross coverage between hwrite and hresp to make sure
            // all the response types are covered for both read and write operations
            cp_hwrite_hresp_cross: cross cp_hwrite, cp_hresp;
        endgroup

        // constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);

            ahb_cover_item = new();
        endfunction

        // write the coverage item to the coverage group ignoring the items which are in progress
        // as they don't have all the signals of a transfer
        virtual function void write(ahb2apb_ahb_item_mon item);
            if (!item.is_in_progress) begin
                ahb_cover_item.sample(item);
            end
        endfunction
    endclass

`endif