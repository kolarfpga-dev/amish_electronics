//Simple register slice for the axi_stream interface
//Single Sided
//Assumes both interfaces are operating on the same clock domain
`include "macros.sv"
module axi_reg_slice(
  interface master,
  interface slave
);
    //Declare a register to save the ready signal driven by the slave
    `reg_decl(out_saved, 1, 'h0, master.clk, master.rst)
    assign slave.clk = master.clk;
    assign slave.rst = master.rst;
   always_comb begin
     out_saved_nxt = slave.tready;
   end
  always @(posedge master.clk) begin
    if(out_saved_reg) begin
      slave.tvalid <= master.tvalid;
      slave.tdata  <= master.tdata;
      slave.tkeep  <= master.tkeep;
      slave.tlast  <= master.tlast;
      slave.tuser  <= master.tuser;
      slave.tid    <= master.tid;
    end
  end
  assign master.tready = out_saved_reg;
endmodule