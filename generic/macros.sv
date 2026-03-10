//Generic SystemVerilog Design Macros
//Add -Edebug "filename" to expand macros in a file
//Declares a register and a comb 
`define reg_decl(name, vec_size, initial_value, clk_name, rst_name) \
logic [vec_size - 1:0] name``_reg;\
logic [vec_size - 1:0] name``_nxt;\
always@(posedge clk_name) begin \
  if(rst_name)\
    name``_reg <= initial_value;\
  else\
    name``_reg <= name``_nxt;\
end