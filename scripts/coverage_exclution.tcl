# default braches
coverage exclude -src ../rtl/cmsdk_ahb_to_apb_async_h.v -line 197 -code s
coverage exclude -src ../rtl/cmsdk_ahb_to_apb_async_p.v -line 135 -code s
coverage exclude -src ../rtl/cmsdk_ahb_to_apb_async_h.v -line 196 -code b
coverage exclude -src ../rtl/cmsdk_ahb_to_apb_async_p.v -line 134 -code b

coverage exclude -src ../rtl/cmsdk_ahb_to_apb_async_syn.v -allfalse -line 53 -code b
# xx states
coverage exclude -du cmsdk_ahb_to_apb_async_p -fstate curr_state xx
coverage exclude -du cmsdk_ahb_to_apb_async_h -fstate curr_state xx

# some signals do not toogle by design
coverage exclude -du cmsdk_ahb_to_apb_async_h -togglenode {HTRANS[0]}
coverage exclude -du cmsdk_ahb_to_apb_async_h -togglenode {HSIZE[2]}
coverage exclude -du cmsdk_ahb_to_apb_async_syn -togglenode enable
coverage exclude -du cmsdk_ahb_to_apb_async_p -togglenode {PPROT[1]}
coverage exclude -du cmsdk_ahb_to_apb_async_p -togglenode {PADDR[0]}
coverage exclude -du cmsdk_ahb_to_apb_async_p -togglenode {PADDR[1]}

# expression exclude
coverage exclude -src ../rtl/cmsdk_ahb_to_apb_async_h.v -line 126 -code e
coverage exclude -src ../rtl/cmsdk_ahb_to_apb_async_h.v -line 128 -code e