module xor_oper(A, B, Y, carry_flag, overflow_flag);
input [63:0]A;
input [63:0]B;
output [63:0]Y;
output carry_flag;
output overflow_flag;

genvar i;
generate
    for(i=0;i < 64;i=i+1) begin
        xor xg1(Y[i], A[i], B[i]);
    end
    buf b1(carry_flag, 0);
    buf b2(overflow_flag, 0);
endgenerate
endmodule