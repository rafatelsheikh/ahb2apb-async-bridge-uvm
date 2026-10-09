// ahb2apb_apb_mem.sv

`ifndef AHB2APB_APB_MEM_SV
    `define AHB2APB_APB_MEM_SV

    class ahb2apb_apb_mem extends uvm_component;

        `uvm_component_utils(ahb2apb_apb_mem)
        int mem[64];
        
        protected bit [7:0] mem [int unsigned];     // APB Memory (associative array)

        function new(string name = "ahb2apb_apb_mem", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void init();
            mem.delete();   // deletes all memory array elemants
        endfunction

        function void write(bit [31:0] addr, bit [31:0] data, bit [3:0] strb = 4'hF);
            bit [31:0] base = {addr[31:2], 2'b00};
            for (int i = 0; i < 4; i++)
                if (strb[i]) 
                mem[base + i] = data[8*i +: 8];
        endfunction

        function bit [31:0] read(bit [31:0] addr);
            bit [31:0] base = {addr[31:2], 2'b00};
            bit [31:0] data;
            for (int i = 0; i < 4; i++) begin
                if(mem.exists(base + i))
                    data[8*i +: 8] = mem[base + i];
                else 
                    data[8*i +: 8] = 8'b0;
            end
            return data;
        endfunction
    endclass

`endif