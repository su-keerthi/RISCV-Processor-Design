
module mux_64(I0, I1, S0, Y);
input [63:0]I0;
input [63:0]I1;
input S0;
output [63:0]Y;

assign Y = S0 ? I1 : I0;
endmodule