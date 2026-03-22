module imm_gen (
    input  [31:0] instr,
    output reg [63:0] imm_out
);

wire [6:0] opcode = instr[6:0];

always @(*) begin
    case (opcode)

        // I type
        7'b0010011, // addi
        7'b0000011: // ld
            imm_out = {{52{instr[31]}}, instr[31:20]}; //sign extending it, take the first 12 bits

        // S type
        7'b0100011:
            imm_out = {{52{instr[31]}}, instr[31:25], instr[11:7]}; //sign extend and take first 7 bits and the 5 bits before opcode

        // B type 
        7'b1100011:
            imm_out = {{51{instr[31]}},   
                           instr[31],        
                           instr[7],         
                           instr[30:25],     
                           instr[11:8], 
                           1'b0      
                          };

        default:
            imm_out = 64'd0;
    endcase
end

endmodule
