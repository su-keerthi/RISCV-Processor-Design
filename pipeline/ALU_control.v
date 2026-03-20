// ALU_control.v
`timescale 1ns/1ps

module ALU_control(
    input  [1:0] ALUOp,      
    input  [2:0] funct3,  // from instruction[14:12]
    input  funct7bit,  // instruction[30]
    output reg [3:0] ALUControl
);

    localparam ADD_Oper  = 4'b0000,
               SLL_Oper  = 4'b0001,
               SLT_Oper  = 4'b0010,
               SLTU_Oper = 4'b0011,
               XOR_Oper  = 4'b0100,
               SRL_Oper  = 4'b0101,
               OR_Oper   = 4'b0110,
               AND_Oper  = 4'b0111,
               SUB_Oper  = 4'b1000,
               SRA_Oper  = 4'b1101;

    always @(*) begin
        case (ALUOp)

            //00 means load store and we need to add to find the offset
            2'b00: ALUControl = ADD_Oper;
            // for compare by subtracting and checking zero flag
            2'b01: ALUControl = SUB_Oper;

            2'b10: begin
                case (funct3) 

                    3'b000: begin
                        // for R type funct7 = 1 means sub, neeed to check funct7 differentiate since func3 is same for both
                        if (funct7bit) ALUControl = SUB_Oper;
                        else           ALUControl = ADD_Oper;
                    end

                    3'b111: ALUControl = AND_Oper;
                    3'b110: ALUControl = OR_Oper;
                    3'b100: ALUControl = XOR_Oper;
                    3'b001: ALUControl = SLL_Oper;
                    3'b101: begin
                        // SRL vs SRA (SRA has funct7=0100000 => bit30=1)
                        if (funct7bit) ALUControl = SRA_Oper;
                        else           ALUControl = SRL_Oper;
                    end

                    3'b010: ALUControl = SLT_Oper;
                    3'b011: ALUControl = SLTU_Oper;
                    default: ALUControl = 4'b1111; //for undefined f3
                endcase
            end

        default: ALUControl = 4'b1111; //for undefined ALUop
        endcase
    end
    
endmodule