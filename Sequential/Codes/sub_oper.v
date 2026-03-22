// `include "cla64.v"
module sub_oper(A, B, S, Cout, carry_flag, overflow_flag);
input [63:0]A;
input [63:0]B;
output [63:0]S;
output Cout;
output carry_flag;
output overflow_flag;

wire [63:0]B_comp;

genvar i;
generate 
    for(i=0;i<64;i=i+1) begin //making 
        not n1(B_comp[i], B[i]);
    end
endgenerate

cla64 sub_copy(
    .A(A),
    .B(B_comp),
    .Cin(1'b1),
    .S(S),
    .Cout(Cout),
    .overflow_flag(overflow_flag)
);

buf b1(carry_flag, Cout);



endmodule