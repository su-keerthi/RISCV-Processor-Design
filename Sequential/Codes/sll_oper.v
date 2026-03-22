// `include "barrel_shift.v"
module sll_oper(A, B, Y, carry_flag, overflow_flag);
input [63:0]A;
input [63:0]B;
output [63:0]Y;
output carry_flag;
output overflow_flag;

barrel_shift left(
    .A(A),
    .B(B),
    .Y(Y),
    .ex(1'b0)
);

buf b1(carry_flag, 0);
buf b2(overflow_flag, 0);
endmodule