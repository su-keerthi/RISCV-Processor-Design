`include "pc.v"
`include "reg_file.v"
`include "instruction_mem.v"
`include "control.v"
`include "imm_gen.v"
`include "ALU_control.v"
`include "alu.v"
`include "data_mem.v"
`include "mux_64.v"

`timescale 1ns / 1ps

module seq_pro(
    input clk,
    input reset
);

    //for pc and instructions
    wire [63:0] pc_out, pc_in;
    wire [31:0] instruction;

    //  
    wire [63:0] read_data1, read_data2;
    wire [63:0] immediate;
    wire [63:0] alu_input2;
    wire [63:0] alu_result;
    wire zero;

    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    wire [63:0] mem_read_data;
    wire [63:0] write_data;

    wire [63:0] pc_plus_4;
    wire [63:0] branch_target;

    // PC
    pc copy_pc (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    cla64 incr_4 (
        .A(pc_out),
        .B(64'd4), 
        .Cin(1'b0),
        .S(pc_plus_4)
    );

    
    cla64 add_branch (
        .A(pc_out),
        .B(immediate),
        .Cin(1'b0),
        .S(branch_target)
    );

    //REGISTER FILE
    reg_file copy_reg_file (
        .clk(clk),
        .reset(reset),
        .read_reg1(instruction[19:15]),
        .read_reg2(instruction[24:20]),
        .write_reg(instruction[11:7]),
        .write_data(write_data),
        .reg_write_en(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    //INS MEM
    instruction_mem copy_inst_mem(
        .addr(pc_out), //give the caluclated pc out as the adress in the inst mem
        .instr(instruction)
    );

    //CONTROL UNIT
    control_unit copy_control_unit (
        .opcode(instruction[6:0]), //last 7 places of the instr
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    // IMM GEN
    imm_gen copy_imm_gen (
        .instr(instruction),
        .imm_out(immediate)
    );

    // ALU CONTROL
    ALU_control copy_alu_cont (
        .ALUOp(ALUOp),
        .funct7bit(instruction[30]),
        .funct3(instruction[14:12]),
        .ALUControl(ALUControl)
    );

    // for alu input2 
    mux_64 mux1(
        .I0(read_data2),
        .I1(immediate),
        .S0(ALUSrc),
        .Y(alu_input2)
    );

    //ALU
    alu ALU_copy(
        .a(read_data1),
        .b(alu_input2),
        .opcode(ALUControl),
        .result(alu_result),
        .zero_flag(zero)
    );

    //DATA MEMORY
    data_mem data_mem_copy (
        .clk(clk),
        .reset(reset),
        .address(alu_result[9:0]),
        .write_data(read_data2),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .read_data(mem_read_data)
    );
    
    mux_64 mux2(
        .I0(alu_result),
        .I1(mem_read_data),
        .S0(MemtoReg),
        .Y(write_data)
    );

    wire to_branch;
    assign to_branch = Branch & zero;
    mux_64 mux3(
        .I0(pc_plus_4),
        .I1(branch_target),
        .S0(to_branch),
        .Y(pc_in)
    );

endmodule