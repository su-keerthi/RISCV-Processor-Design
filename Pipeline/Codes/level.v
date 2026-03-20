// `include "mux.v"
module level #(parameter integer k = 1) (A, B, Y, ex); //k is the amount we need to shift it depending on the level
input [63:0]A; 
input B;
input ex;
output [63:0]Y;
//k is a paremeter that is set to 1 as default, its not an input cos it must be known at compile time

genvar i;
generate
    for(i=0;i<64;i=i+1) begin 
        if(i<k) begin: first 
            mux m1
            (
                .I0(A[i]),
                .I1(ex),
                .S0(B),
                .Y(Y[i])
            );
        end

        else begin: next
            mux m2
            (
                .I0(A[i]),
                .I1(A[i-k]),
                .S0(B),
                .Y(Y[i])
            );
        end
    end

endgenerate
endmodule