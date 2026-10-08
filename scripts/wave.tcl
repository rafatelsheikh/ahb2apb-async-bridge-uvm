# AHB Interface (Yellow)
add wave -divider "AHB interface signals"
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HCLK
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HRESETn
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HSEL
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HADDR
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HTRANS
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HSIZE
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HPROT
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HWRITE
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HREADY
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HWDATA
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HRESP

add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HREADYOUT
add wave -noupdate -color "Yellow" /ahb2apb_testbench/DUT/HRDATA

add wave -divider "APB interface signals"
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PCLK
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/APBACTIVE
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PRESETn
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PSEL
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PADDR
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PENABLE
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PSTRB
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PPROT
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PWRITE
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PWDATA

add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PREADY
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PSLVERR
add wave -noupdate -color "Cyan" /ahb2apb_testbench/DUT/PRDATA