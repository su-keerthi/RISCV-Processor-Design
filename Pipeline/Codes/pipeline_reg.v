module IF_ID_reg(
    input clk,
    input reset,
    input stall,
    input flush,
    input [63:0] pc_in,
    output reg [63:0] pc_out,
    input [31:0]ins_in,
    output reg [31:0]ins_out
);

always @(posedge clk) begin
    if(reset || flush)begin
        pc_out <= 64'b0; //we want to update simultaneously
        ins_out <= 32'h00000033; //to do nothing
    end
    else if(!stall)begin
        pc_out <= pc_in;
        ins_out <= ins_in;
    end

    //if its a stall nothing happens
end
endmodule

module ID_EX_reg(
    //controls
    input clk,
    input reset,
    input flush,
    input RegWrite_in, MemtoReg_in, MemRead_in, MemWrite_in, Branch_in, ALUSrc_in,
    input [1:0] ALUOp_in,
    input [2:0] id_funct3,
    input [6:0] id_funct7,

    //inputs
    input [63:0] pc_in,
    input [63:0] s1_data_in,
    input [4:0] s1_add_in,
    input [63:0] s2_data_in,
    input [4:0] s2_add_in,
    input [63:0] imm_in,
    input [4:0] d_add_in,

    //output
    output reg RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out, Branch_out, ALUSrc_out,
    output reg [1:0] ALUOp_out,
    output reg [63:0] pc_out,
    output reg [63:0] s1_data_out,
    output reg [4:0] s1_add_out,
    output reg [63:0] s2_data_out,
    output reg [4:0] s2_add_out,
    output reg [63:0] imm_out,
    output reg [4:0] d_add_out,
    output reg [2:0] ex_funct3,
    output reg [6:0] ex_funct7

);

always @(posedge clk) begin

    //make all controls and o/p as 0
    if(reset || flush) begin
        RegWrite_out <= 0;
        MemtoReg_out <= 0;
        MemRead_out <= 0;
        MemWrite_out <= 0;
        Branch_out <= 0;
        ALUSrc_out <= 0;
        ALUOp_out <= 2'd0;

        pc_out <= 64'd0;
        s1_data_out <= 64'd0;
        s2_data_out <= 64'd0;
        imm_out <= 64'd0;
        s1_add_out <= 5'd0;
        s2_add_out <= 5'd0;
        d_add_out <= 5'd0;
        ex_funct3 <= 3'd0;
        ex_funct7 <= 7'd0;
        
    end
    
    else begin
        RegWrite_out <= RegWrite_in;
        MemtoReg_out <= MemtoReg_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        Branch_out <= Branch_in;
        ALUSrc_out <= ALUSrc_in;
        ALUOp_out <= ALUOp_in;
        pc_out <= pc_in;
        s1_data_out <= s1_data_in;
        s2_data_out <= s2_data_in;
        imm_out <= imm_in;
        s1_add_out <= s1_add_in;
        s2_add_out <= s2_add_in;
        d_add_out <= d_add_in;
        ex_funct3 <= id_funct3;
        ex_funct7 <= id_funct7;
        
    end
end
endmodule

module EX_MEM_reg(
    //controls
    input clk,
    input reset,

    //passed inputs
    input RegWrite_in, MemtoReg_in, MemRead_in, MemWrite_in, Branch_in,

    input [63:0] target_in,
    input zero_in,
    input [63:0] alu_res_in,
    input [4:0] d_add_in,
    input [63:0] s2_data_in,

    output reg RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out, Branch_out,
    output reg [63:0] target_out,
    output reg zero_out,
    output reg [63:0] alu_res_out,
    output reg [4:0] d_add_out,
    output reg [63:0] s2_data_out
);

always @(posedge clk) begin
    if(reset) begin
        RegWrite_out <= 0;
        MemtoReg_out <= 0;
        MemRead_out  <= 0;
        MemWrite_out <= 0;
        Branch_out   <= 0;

        target_out   <= 64'd0;
        zero_out     <= 0;
        alu_res_out  <= 64'd0;
        s2_data_out  <= 64'd0;
        d_add_out    <= 5'd0;
    end
    else begin
        RegWrite_out <= RegWrite_in;
        MemtoReg_out <= MemtoReg_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        Branch_out <= Branch_in;
        target_out <= target_in;
        zero_out <= zero_in;
        alu_res_out <= alu_res_in;
        s2_data_out <= s2_data_in;
        d_add_out <= d_add_in;
    end  
end
endmodule

module MEM_WB_reg(
    input clk,
    input reset,

    input RegWrite_in, MemtoReg_in,

    //stuff from memory/ex stages
    input [63:0] mem_read_data_in,
    input [63:0] alu_res_in,
    input [4:0] d_add_in,

    output reg RegWrite_out, MemtoReg_out,
    //stuff from memory/ex stages
    output reg [63:0] mem_read_data_out,
    output reg [63:0] alu_res_out,
    output reg [4:0] d_add_out
);

    always @(posedge clk) begin
        if(reset) begin
            RegWrite_out      <= 0;
            MemtoReg_out      <= 0;
            mem_read_data_out <= 64'd0;
            alu_res_out       <= 64'd0;
            d_add_out         <= 5'd0;
        end
        else begin
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            mem_read_data_out <= mem_read_data_in;
            alu_res_out <= alu_res_in;
            d_add_out <= d_add_in;
        end
    end
endmodule