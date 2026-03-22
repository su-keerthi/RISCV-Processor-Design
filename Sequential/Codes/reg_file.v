// reg_file.v
`timescale 1ns/1ps

module reg_file(
    input clk,
    input reset,
    input [4:0]read_reg1,
    input [4:0]read_reg2,
    input [4:0]write_reg,
    input [63:0]write_data,
    input  reg_write_en,
    output [63:0]  read_data1,
    output [63:0]  read_data2
);

    
    reg [63:0] regs [0:31];
    integer i;

    // Synchronous reset and write
    always @(posedge clk) begin
        if (reset) begin //make em all zero
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 64'd0;
            end
        end else begin
            // Write on rising edge if enabled and not x0
            if (reg_write_en && (write_reg != 5'd0)) begin
                regs[write_reg] <= write_data;
            end
        end
    end

    assign read_data1 = (read_reg1 == 5'd0) ? 64'd0 : regs[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 64'd0 : regs[read_reg2];


endmodule