module mux(I0, I1, S0, Y);
input I0;
input I1;
input S0;
output Y;

wire S0_comp, t1, t2;
not n1(S0_comp, S0);
and a1(t1, S0_comp, I0);
and a2(t2, S0, I1);
or o1(Y, t1, t2);
endmodule
