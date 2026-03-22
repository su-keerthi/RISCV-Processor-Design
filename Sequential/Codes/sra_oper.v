// `include "barrel_shift.v"
module sra_oper(A, B, Y, carry_flag, overflow_flag);
input [63:0]A;
input [63:0]B;
output [63:0]Y;
output carry_flag;
output overflow_flag;

genvar i;
wire [63:0]T;
wire [63:0]S;
wire msb;

buf b3(msb, A[63]); //assign msb as the extension bit

//need to give a reversed output, hardware is the same as before
generate
    for(i=0; i<64;i=i+1) begin: swap_in
        buf b1(T[i], A[63-i]); //apparently theres a buffer, Ive been using and gate till now
    end
endgenerate

barrel_shift right(
    .A(T),
    .B(B),
    .Y(S),
    .ex(msb)
);

//need to reverse the output as well
genvar j;
generate
    for(j=0; j<64;j=j+1) begin: swap_out
        buf b2(Y[j], S[63-j]);
    end
endgenerate
buf b4(carry_flag, 0);
buf b5(overflow_flag, 0);

endmodule
