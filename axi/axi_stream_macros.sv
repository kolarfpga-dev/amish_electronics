`define AXI_S_INTF_CONNECT(master_interface, slave_interface) \
  assign slave_interface.clk     = master_interface.clk; \
  assign slave_interface.rst     = master_interface.rst;\
  assign slave_interface.tvalid  = master_interface.tvalid;\
  assign master_interface.tready = slave_interface.tready;\
  assign slave_interface.tdata   = master_interface.tdata;\
  assign slave_interface.tkeep   = master_interface.tkeep;\
  assign slave_interface.tlast   = master_interface.tlast;\
  assign slave_interface.tuser   = master_interface.tuser; \
  assign slave_interface.tid     = master_interface.tid;

`define AXI_S_COMB_CONNECT(master_interface, slave_interface)\
  slave_interface.tvalid   = master_interface.tvalid;\
  master_interface.tready  = slave_interface.tready;\
  slave_interface.tdata    = master_interface.tdata;\
  slave_interface.tkeep    = master_interface.tkeep;\
  slave_interface.tlast    = master_interface.tlast;\
  slave_interface.tuser    = master_interface.tuser;\
  slave_interface.tid      = master_interface.tid;

//SS-Clone Creates an ss_inst with the same parameters as an existing one
`define AXI_S_CLONE(original_inst_name, cloned_inst_name) \
axi_s#(.DATA_W(original_inst_name.DATA_W), .USER_W(original_inst_name.USER_W), .TID_W(original_inst_name.TID_W)) cloned_inst_name();

//Clone and Connect
`define AXI_S_INTF_CC(mast_intf_name, slave_intf_name)\
`AXI_S_CLONE(mast_intf_name, slave_intf_name)\
`AXI_S_INTF_CONNECT(mast_intf_name, slave_intf_name)