
module pc_pipe(clk, reset, pc_in, pc_out, stall_pc);
input clk;
input reset;
input [63:0]pc_in;
input stall_pc;
output reg [63:0]pc_out;
//adding an enable for stall cases

always @(posedge clk) begin
    if (reset)
        pc_out <= 64'b0;
    else if(!stall_pc)
    pc_out <= pc_in;
end

endmodule
