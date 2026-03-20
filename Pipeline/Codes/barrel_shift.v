// `include "level.v"
module barrel_shift(A, B, Y, ex);
input [63:0]A;
input [63:0]B;
input ex;
output [63:0]Y;
wire [63:0]t1, t2, t3, t4, t5, t6;
//considering that only the last 6 bits are used for shifting and the others are ignored

level #(1) level1( //shifts by 1
    .A(A),
    .B(B[0]),
    .Y(t1),
    .ex(ex)
);

level #(2) level2( //by 2
    .A(t1),
    .B(B[1]),
    .Y(t2),
    .ex(ex)
);
 
level #(4) level3( //by 4
    .A(t2),
    .B(B[2]),
    .Y(t3),
    .ex(ex)
);

level #(8) level4( //by 8
    .A(t3),
    .B(B[3]),
    .Y(t4),
    .ex(ex)
);

level #(16) level5( //yeah you get the point :)
    .A(t4),
    .B(B[4]),
    .Y(t5),
    .ex(ex)
);

level #(32) level6(
    .A(t5),
    .B(B[5]),
    .Y(Y),
    .ex(ex)
);

endmodule