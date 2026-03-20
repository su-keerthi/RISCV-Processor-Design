module cla4(A, B, Cin, S, Cout);
input [3:0]A;
input [3:0]B;
input Cin;
output [3:0]S;
output Cout;
wire [3:0]P;
wire [3:0]G;
wire [4:0]C;
wire t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;

and a12(C[0], Cin, 1'b1);

//finding propogate and carry arrays
genvar i;
generate
    for(i=0;i<4;i=i+1) begin : pg
        xor x1(P[i], A[i], B[i]);
        and a1(G[i], A[i], B[i]);
    end
endgenerate

//finding C1
and a2(t10, P[0], C[0]);
or o1(C[1], t10, G[0]);

//finding C2
and a3(t1, P[1], P[0], C[0]);
and a4(t2, P[1], G[0]);
or o2(C[2], G[1], t2, t1);

//finding C3
and a5(t3, P[2], P[1], P[0], C[0]);
and a6(t4, P[2], P[1], G[0]);
and a7(t5, P[2], G[1]);
or o3(C[3], G[2], t5, t4, t3);

//finding C4
and a8(t6, P[3], P[2], P[1], P[0], C[0]);
and a9(t7, P[3], P[2], P[1], G[0]);
and a10(t8, P[3], P[2], G[1]);
and a11(t9, P[3], G[2]);
or o4(C[4], G[3], t9, t8, t7, t6);

assign Cout = C[4];

//finding sum array
genvar j;
generate
    for(j=0; j<4; j=j+1) begin: sum
        xor x2(S[j], P[j], C[j]);
    end
endgenerate
endmodule