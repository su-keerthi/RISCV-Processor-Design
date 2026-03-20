// `include "sltu_oper.v"
module slt_oper(A, B, Y, carry_flag, overflow_flag);
input [63:0]A;
input [63:0]B;
output [63:0]Y;
output carry_flag;
output overflow_flag;

//for A < B either we need A negative and B positive or both have same signs and the rest are less than B

wire t1, t2;
not n1(t1, B[63]);
and a1(sign, A[63], t1); //this is one when A is negative and B is positive

wire same, t3;
xor x1(t3, A[63], B[63]);
not n2(same, t3); //basically xnor - gives one if both the bits are the same

wire [63:0]rem;
sltu_oper copy(
    .A(A),
    .B(B),
    .Y(rem) //Y[0] is 1 only if A < B using slt
);

wire t4, t5;
and a2(t4, rem[0], same); //1 only when both same and rem are satisfied
or o1(t5, t4, sign); //one only when either of the stuff are satisfied, so Y[0] should be 1

genvar i;
generate
    for(i = 1; i < 64; i=i+1) begin
        and a3(Y[i], 0, B[i]); //this is me not knowing buffer existed :') 
    end
endgenerate

and a4(Y[0], t5, 1); //again, buffer ignorance 


buf b1(carry_flag, 0); //finally has learnt about buffers
buf b2(overflow_flag, 0);

endmodule