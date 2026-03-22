// control.v
`timescale 1ns/1ps

module control_unit(
    input  [6:0] opcode,
    output reg  Branch,
    output reg  MemRead,
    output reg  MemtoReg,
    output reg [1:0] ALUOp,
    output reg  MemWrite,
    output reg  ALUSrc,
    output reg  RegWrite
);

    localparam OPC_RTYPE  = 7'b0110011; 
    localparam OPC_ITYPE  = 7'b0010011; 
    localparam OPC_LOAD   = 7'b0000011; 
    localparam OPC_STORE  = 7'b0100011; 
    localparam OPC_BRANCH = 7'b1100011; 

    always @(*) begin

        //Default to setting everything to 0
        Branch   = 0;
        MemRead  = 0;
        MemtoReg = 0;
        ALUOp    = 2'b00;
        MemWrite = 0;
        ALUSrc   = 0;
        RegWrite = 0;

        case (opcode)

            // R-type
            OPC_RTYPE: begin
                RegWrite = 1;
                ALUSrc   = 0;
                MemtoReg = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b10; //determined by operation encoded in funct7 and funct3 fields
            end

            // I-type 
            OPC_ITYPE: begin
                RegWrite = 1;
                ALUSrc   = 1;
                MemtoReg = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00; 
            end

            // LOAD
            OPC_LOAD: begin
                RegWrite = 1;
                ALUSrc   = 1;
                MemtoReg = 1;
                MemRead  = 1;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00; //for load/store
            end

            // STORE
            OPC_STORE: begin
                RegWrite = 0;
                ALUSrc   = 1;
                MemtoReg = 0;
                MemRead  = 0;
                MemWrite = 1;
                Branch   = 0;
                ALUOp    = 2'b00; //for load/store
            end

            // BRANCH (BEQ)
            OPC_BRANCH: begin
                RegWrite = 0;
                ALUSrc   = 0;
                MemtoReg = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 1;
                ALUOp    = 2'b01; //for beq
            end

            default: begin
                // Remain NOP
            end

        endcase
    end

endmodule