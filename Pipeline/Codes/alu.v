`include "mux.v"
`include "level.v"
`include "barrel_shift.v"
`include "cla4.v"
`include "cla64.v"
`include "add_oper.v"
`include "sub_oper.v"
`include "xor_oper.v"
`include "or_oper.v"
`include "and_oper.v"
`include "sll_oper.v"
`include "srl_oper.v"
`include "sra_oper.v"
`include "slt_oper.v"
`include "sltu_oper.v"

module alu(a, b, opcode, result, cout, carry_flag, overflow_flag, zero_flag);
input [63:0]a;
input [63:0]b;
input [3:0]opcode;
output reg [63:0]result;
output reg cout, carry_flag, overflow_flag, zero_flag; //need to be registers to use in the always block

localparam ADD_Oper  = 4'b0000,
           SLL_Oper  = 4'b0001,
           SLT_Oper  = 4'b0010,
           SLTU_Oper = 4'b0011,
           XOR_Oper  = 4'b0100,
           SRL_Oper  = 4'b0101,
           OR_Oper   = 4'b0110,
           AND_Oper  = 4'b0111,
           SUB_Oper  = 4'b1000,
           SRA_Oper  = 4'b1101;

wire [63:0] add_y, sub_y, and_y, or_y, xor_y, srl_y, sll_y, sra_y, slt_y, sltu_y;
wire add_cout_y, sub_cout_y, c_add, o_add, c_sub, o_sub, c_and, o_and, c_or, o_or, c_xor, o_xor, c_sll, o_sll, c_srl, o_srl, c_sra, o_sra, c_slt, o_slt, c_sltu, o_sltu;

add_oper copy_add(.A(a), .B(b), .S(add_y), .Cout(add_cout_y), .carry_flag(c_add), .overflow_flag(o_add));
sub_oper copy_sub(.A(a), .B(b), .S(sub_y), .Cout(sub_cout_y), .carry_flag(c_sub), .overflow_flag(o_sub));
and_oper copy_and(.A(a), .B(b), .Y(and_y), .carry_flag(c_and), .overflow_flag(o_and));
or_oper  copy_or (.A(a), .B(b), .Y(or_y), .carry_flag(c_or), .overflow_flag(o_or));
xor_oper copy_xor(.A(a), .B(b), .Y(xor_y), .carry_flag(c_xor), .overflow_flag(o_xor));
sll_oper copy_sll(.A(a), .B(b), .Y(sll_y), .carry_flag(c_sll), .overflow_flag(o_sll));
srl_oper copy_srl(.A(a), .B(b), .Y(srl_y), .carry_flag(c_srl), .overflow_flag(o_srl));
sra_oper copy_sra(.A(a), .B(b), .Y(sra_y), .carry_flag(c_sra), .overflow_flag(o_sra));
slt_oper  copy_slt (.A(a), .B(b), .Y(slt_y), .carry_flag(c_slt), .overflow_flag(o_slt));
sltu_oper copy_sltu(.A(a), .B(b), .Y(sltu_y), .carry_flag(c_sltu), .overflow_flag(o_sltu));

always @(*) begin
    result        = 64'd0;
    cout          = 1'b0;
    carry_flag    = 1'b0;
    overflow_flag = 1'b0;

    case(opcode)
    ADD_Oper: begin
        result = add_y;
        cout = add_cout_y;
        carry_flag = c_add;
        overflow_flag = o_add;
    end 


    SUB_Oper: begin
        result = sub_y;
        cout = sub_cout_y;
        carry_flag = c_sub;
        overflow_flag = o_sub;
    end

    AND_Oper: begin
        result = and_y;
        carry_flag = c_and;
        overflow_flag = o_and;
    end

    OR_Oper: begin
        result = or_y;
        carry_flag = c_or;
        overflow_flag = o_or;
    end

    XOR_Oper: begin
        result = xor_y;
        carry_flag = c_xor;
        overflow_flag = o_xor;
    end

    SLL_Oper: begin
        result = sll_y;
        carry_flag = c_sll;
        overflow_flag = o_sll;
    end

    SRL_Oper: begin
        result = srl_y;
        carry_flag = c_srl;
        overflow_flag = o_srl;
    end

    SRA_Oper: begin
        result = sra_y;
        carry_flag = c_sra;
        overflow_flag = o_sra;
    end

    SLT_Oper: begin
        result = slt_y;
        carry_flag = c_slt;
        overflow_flag = o_slt;
    end

    SLTU_Oper: begin
        result = sltu_y;
        carry_flag = c_sltu;
        overflow_flag = o_sltu;
    end

    default: begin
        result = 64'b0;
    end
    endcase
    zero_flag = (result == 64'b0);
end
endmodule