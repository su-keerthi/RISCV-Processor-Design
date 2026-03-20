// `include "cla64.v"
module add_oper(A, B, S, Cout, carry_flag, overflow_flag);

input [63:0]A;
input [63:0]B;
output [63:0]S;
output Cout;
output carry_flag;
output overflow_flag;

cla64 add_copy(
    .A(A),
    .B(B),
    .Cin(1'b0),
    .S(S),
    .Cout(Cout),
    .overflow_flag(overflow_flag)
);

buf b1(carry_flag, Cout);

endmodule
