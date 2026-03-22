// `include "cla4.v"

module cla64(A, B, Cin, S, Cout, overflow_flag);
input [63:0]A;
input [63:0]B;
input Cin;
output [63:0]S;
output Cout;
output overflow_flag;

wire t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16;

cla4 cla4_1(
    .A(A[3:0]),
    .B(B[3:0]),
    .Cin(Cin),
    .S(S[3:0]),
    .Cout(t1)
);

cla4 cla4_2(
    .A(A[7:4]),
    .B(B[7:4]),
    .Cin(t1),
    .S(S[7:4]),
    .Cout(t2)
);

cla4 cla4_3(
    .A(A[11:8]),
    .B(B[11:8]),
    .Cin(t2),
    .S(S[11:8]),
    .Cout(t3)
);

cla4 cla4_4(
    .A(A[15:12]),
    .B(B[15:12]),
    .Cin(t3),
    .S(S[15:12]),
    .Cout(t4)
);

cla4 cla4_5(
    .A(A[19:16]),
    .B(B[19:16]),
    .Cin(t4),
    .S(S[19:16]),
    .Cout(t5)
);

cla4 cla4_6(
    .A(A[23:20]),
    .B(B[23:20]),
    .Cin(t5),
    .S(S[23:20]),
    .Cout(t6)
);

cla4 cla4_7(
    .A(A[27:24]),
    .B(B[27:24]),
    .Cin(t6),
    .S(S[27:24]),
    .Cout(t7)
);

cla4 cla4_8(
    .A(A[31:28]),
    .B(B[31:28]),
    .Cin(t7),
    .S(S[31:28]),
    .Cout(t8)
);

cla4 cla4_9(
    .A(A[35:32]),
    .B(B[35:32]),
    .Cin(t8),
    .S(S[35:32]),
    .Cout(t9)
);

cla4 cla4_10(
    .A(A[39:36]),
    .B(B[39:36]),
    .Cin(t9),
    .S(S[39:36]),
    .Cout(t10)
);

cla4 cla4_11(
    .A(A[43:40]),
    .B(B[43:40]),
    .Cin(t10),
    .S(S[43:40]),
    .Cout(t11)
);

cla4 cla4_12(
    .A(A[47:44]),
    .B(B[47:44]),
    .Cin(t11),
    .S(S[47:44]),
    .Cout(t12)
);

cla4 cla4_13(
    .A(A[51:48]),
    .B(B[51:48]),
    .Cin(t12),
    .S(S[51:48]),
    .Cout(t13)
);

cla4 cla4_14(
    .A(A[55:52]),
    .B(B[55:52]),
    .Cin(t13),
    .S(S[55:52]),
    .Cout(t14)
);

cla4 cla4_15(
    .A(A[59:56]),
    .B(B[59:56]),
    .Cin(t14),
    .S(S[59:56]),
    .Cout(t15)
);

cla4 cla4_16(
    .A(A[63:60]),
    .B(B[63:60]),
    .Cin(t15),
    .S(S[63:60]),
    .Cout(Cout)
);

xor x1(overflow_flag, t15, Cout);


endmodule
