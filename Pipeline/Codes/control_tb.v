// control_tb.v
`timescale 1ns/1ps

module control_unit_tb;

    reg  [6:0] opcode;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUOp;

    control_unit uut (
        .opcode(opcode),
        .Branch(Branch), 
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    initial begin
        $dumpfile("control_wave.vcd");
        $dumpvars(0, control_unit_tb);

        // 1) R-type (ADD)
        opcode = 7'b0110011;
        #5;
        $display("\nR-TYPE");
        $display("opcode=%b Branch=%0d MemRead=%0d MemtoReg=%0d ALUOp=%b MemWrite=%0d ALUSrc=%0d RegWrite=%0d",
                 opcode, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

        // 2) I-type ALU (ADDI)
        opcode = 7'b0010011;
        #5;
        $display("\nI-TYPE");
        $display("opcode=%b Branch=%0d MemRead=%0d MemtoReg=%0d ALUOp=%b MemWrite=%0d ALUSrc=%0d RegWrite=%0d",
                 opcode, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

        // 3) LOAD (LD)
        opcode = 7'b0000011;
        #5;
        $display("\nLOAD");
        $display("opcode=%b Branch=%0d MemRead=%0d MemtoReg=%0d ALUOp=%b MemWrite=%0d ALUSrc=%0d RegWrite=%0d",
                 opcode, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

        // 4) STORE (SD)
        opcode = 7'b0100011;
        #5;
        $display("\nSTORE");
        $display("opcode=%b Branch=%0d MemRead=%0d MemtoReg=%0d ALUOp=%b MemWrite=%0d ALUSrc=%0d RegWrite=%0d",
                 opcode, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

        // 5) BRANCH (BEQ)
        opcode = 7'b1100011;
        #5;
        $display("\nBRANCH");
        $display("opcode=%b Branch=%0d MemRead=%0d MemtoReg=%0d ALUOp=%b MemWrite=%0d ALUSrc=%0d RegWrite=%0d",
                 opcode, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

        // 6) Unknown opcode → NOP behavior
        opcode = 7'b1111111;
        #5;
        $display("\nUNKNOWN");
        $display("opcode=%b Branch=%0d MemRead=%0d MemtoReg=%0d ALUOp=%b MemWrite=%0d ALUSrc=%0d RegWrite=%0d",
                 opcode, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

        $finish;
    end

endmodule