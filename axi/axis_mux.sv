//Description: Basic AXIS Mux. Could technically improve performance by selecting a new interface
//on the last beat on a current packet. Lowest number interface gets priority

module axis_mux#(
    parameter NUM_INTERFACES = 4
)(
    interface masters[NUM_INTERFACES - 1:0],//Interfaces giving data to module
    interface slave//Interface with muxed data
);
typedef enum logic [0:0] {
    1'h0 = IDLE,
    1'h1 = STEAMING
} SM_T;
logic clk, rst;
//State machine register
`reg_decl(sm, SM_T, IDLE, clk, rst)
//Currently streaming interface
`reg_decl(logic [$clog2(NUM_INTERFACES) - 1:0], selected_intf, 'hx, clk, rst)
logic [NUM_INTERFACES - 1:0] master_valids; 
assign clk = masters[0].clk;
assign rst = masters[0].rst;

genvar i; 
generate
    for(i = 0; i < NUM_INTERFACES, i++) begin
        assign master_valids[i] = masters[i].tvalid;
    end
endgenerate

function logic[$clog2(NUM_INTERFACES) - 1:0] select_new_intf();
    for(int i = 0; i < NUM_INTERFACES; i++) begin
        if(masters[i].tvalid) begin
            return i;
        end
    end
    return 'h0;//Should never return this...something should be valid
endfunction

always_comb begin 
    sm_nxt = sm_reg;
    selected_intf_nxt = selected_intf_nxt;
    //Default slave values
    slave.tvalid = 'h0;
    slave.tkeep  = 'hx;
    slave.tuser  = 'hx;
    slave.tid    = 'hx;
    slave.tlast  = 'hx;
    case(sm)
        IDLE: begin
            if(!(|master_valids)) begin //Not streaming and no data
                serviced_nxt = 'h0;//Reset serviced
            end else begin//Not streaming and data is available
                selected_intf_nxt = select_new_intf();//Selected new interface
                `AXI_S_COMB_CONNECT(master_interface[select_new_intf()], slave_interface)
                if(masters[select_new_intf()].tlast) begin//First and last beat
                end else begin//First, but not last data beat
                    sm_nxt = STEAMING;
                end
            end
        end
        STEAMING: begin
            `AXI_S_COMB_CONNECT(master_interface[selected_intf_reg], slave_interface)
            if(masters[selected_intf_reg].tvalid && slave.tready && masters[selected_intf_reg].tlast) begin
                //Done with current packet
                sm_nxt = IDLE;        
            end
        end
        default: begin
        end
    endcase