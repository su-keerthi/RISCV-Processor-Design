// `include "sub_oper.v"
module sltu_oper(A, B, Y, carry_flag, overflow_flag);
input  [63:0]A;
input  [63:0]B;
output [63:0]Y;
output carry_flag;
output overflow_flag;
wire [63:0]S;
wire Cout;

sub_oper copy(
    .A(A),
    .B(B),
    .S(S),
    .Cout(Cout)
);

genvar i;
    generate
        for(i = 1; i < 64; i=i+1) begin
            and ag1(Y[i], 0, B[i]);
        end
    endgenerate
//check based on the subtraction difference, if Cout = 1, this means borrow = 0, this means A > B, so answer needs to be 0, so Y = ~Cout
not n1 (Y[0], Cout);

buf b1(carry_flag, 0);
buf b2(overflow_flag, 0);

endmodule
