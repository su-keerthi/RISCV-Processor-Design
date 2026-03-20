module hazard_detection(
    input [4:0] idex_d, //dest register of the ex ins
    input idex_memread, //tells if it is a load
    input [4:0] ifid_s1 ,
    input [4:0] ifid_s2, 
    output reg stall_pc,
    output reg stall_ifid,
    output reg flush_idex
);

//load use harzards need stalling, mem_read checks if its a load 
//if they match need to stall so stall = 1, else stall = 0
always @(*) begin
    //check if its in the execute stage
    if(idex_memread && (idex_d != 5'b0) && ((idex_d == ifid_s1) || (idex_d == ifid_s2))) begin
        stall_pc = 1'b1;  //PC = PC
        stall_ifid = 1'b1; //keep ifid register the same
        flush_idex = 1'b1; //gives a NOP so that nothing is executed
    end
    else begin
        stall_pc = 1'b0; 
        stall_ifid = 1'b0;
        flush_idex = 1'b0;
    end
end

endmodule