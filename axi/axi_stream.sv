//Description: Axi stream interface
//Date: 3/10/26
//Author: James Kolar

interface axi_s#(
    parameter DATA_W = 8,//Custom data width, number of bytes
    parameter USER_W = 1,//Custom user width
    parameter TID_W  = 1//Transaction ID width
    );
    logic clk;
    logic rst;

    logic [DATA_W - 1:0][7:0] tdata;
    logic [DATA_W - 1:0]      tkeep;
    logic [USER_W - 1:0]      tuser;
    logic [TID_W  - 1:0]      tid;
    logic                     tvalid;
    logic                     tready;
    logic                     tlast;
endinterface
