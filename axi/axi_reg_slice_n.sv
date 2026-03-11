//Generates n number of register slices
//Creates 0 or more register slices
//Does NOT perform any type of clock domain crossing
`include "axi_stream_macros.sv"
module axi_reg_slice_n#(parameter NUM_REG_SLICES = 2)(
  interface master,
  interface slave
);

    generate//If it is 0 register slices, we have a special condition
        if(NUM_REG_SLICES == 0) begin
            `AXI_S_INTF_CONNECT(master, slave)
        end
    endgenerate

    generate
        if(NUM_REG_SLICES > 0) begin
            genvar i;
            //Instantiate the appropriate number of interfaces
            `AXI_S_CLONE(master, middle_interfaces[NUM_REG_SLICES:0])
            `AXI_S_INTF_CONNECT(master, middle_interfaces[0])//Connect to the first "middle interface"
            for(i = 0; i < NUM_REG_SLICES; i++) begin
                axi_reg_slice inst(middle_interfaces[i], middle_interfaces[i+1]);
            end
            `AXI_S_INTF_CONNECT(middle_interfaces[NUM_REG_SLICES], slave)
        end
    endgenerate
endmodule