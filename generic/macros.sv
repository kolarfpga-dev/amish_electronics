//Generic SystemVerilog Design Macros
//Add -Edebug "filename" to expand macros in a file
//Declares a register and a comb 
`define reg_decl(name, the_type, initial_value, clk_name, rst_name) \
the_type name``_reg;\
the_type name``_nxt;\
always@(posedge clk_name) begin \
  if(rst_name)\
    name``_reg <= initial_value;\
  else\
    name``_reg <= name``_nxt;\
end