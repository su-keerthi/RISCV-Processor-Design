module forwarding_unit(
    input [4:0] idex_s1,
    input [4:0] idex_s2,
    input [4:0] exmem_d,
    input [4:0] memwb_d,
    input exmem_reg_write,
    input memwb_reg_write,
    output reg [1:0] cont_A, //goes as control for MUX
    output reg [1:0] cont_B
);

always @(*) begin
    //case of no forwarding
    cont_A = 2'b00;
    cont_B = 2'b00; //00 = original

    //mem stage is writing to a register that execute needs 
    if(exmem_reg_write && (exmem_d != 5'b0)) begin
        if(exmem_d == idex_s1) cont_A = 2'b10;
        if(exmem_d == idex_s2) cont_B = 2'b10; //10 = MEM
    end

    //write back stage is writing to a register that ex needs - NORMAL
    //an extra check to make sure wb forwarding happens only when mem forwarding isnt happeneing
    // cant use else if statements 
    if(memwb_reg_write && (memwb_d != 5'b0)) begin
        if(cont_A == 2'b00 && (memwb_d == idex_s1)) cont_A = 2'b01;
        if(cont_B == 2'b00 && (memwb_d == idex_s2)) cont_B = 2'b01; //01 = WB
    end

end

endmodule