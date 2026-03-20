`include "mux3.v"
`include "forwarding_unit.v"
`include "hazard_detection.v"
`include "pc_pipe.v"
`include "reg_file.v"
`include "instruction_mem.v"
`include "control.v"
`include "imm_gen.v"
`include "ALU_control.v"
`include "alu.v"
`include "data_mem.v"
`include "mux_64.v"
`include "pipeline_reg.v"


//branch-2 cycle penalty

module processor(
    input clk,
    input reset
);


// (wires driven by later-instantiated modules, needed before use)


// From EX/MEM register
wire        mem_RegWrite;
wire [4:0]  mem_rd;
wire [63:0] mem_alu_result;
wire        mem_MemRead;
wire        mem_MemWrite;
wire        mem_MemtoReg;
wire [63:0] mem_write_data;
// mem_branch / mem_zero not used for branch decision (EX handles it)

// From MEM/WB register
wire        wb_RegWrite;
wire [4:0]  wb_rd;
wire        wb_MemtoReg;
wire [63:0] wb_read_data;
wire [63:0] wb_alu_result;
wire [63:0] wb_write_data;
assign wb_write_data = wb_MemtoReg ? wb_read_data : wb_alu_result;

// From ID/EX register (needed by hazard detection unit)
wire        ex_MemRead;
wire [4:0]  ex_rd;

// EX stage branch signals (forward declared, assigned after EX stage below)
wire        ex_Branch_out;   // from ID/EX register
wire        ex_zero;         // from ALU
wire [63:0] ex_branch_target;

// Branch resolved in EX stage
wire branch_taken;
assign branch_taken = ex_Branch_out & ex_zero;

// Hazard detection outputs
wire stall_pc, stall_if_id, flush_id_ex;

// Flush signals
// On branch: flush IF/ID (wrong instr in ID) and ID/EX (insert bubble into EX)
wire flush_if_id_sig = branch_taken;

 wire flush_id_ex_sig = flush_id_ex | branch_taken;      


// IF STAGE

wire [63:0] pc_out;
wire [63:0] pc_plus4;
wire [63:0] pc_next;
wire [31:0] if_instr;

assign pc_plus4 = pc_out + 64'd4;
//mux to branch or not to branch
assign pc_next  = branch_taken ? ex_branch_target : pc_plus4; 

pc_pipe PC(
    .clk(clk),
    .reset(reset),
    .stall_pc(stall_pc),
    .pc_in(pc_next),
    .pc_out(pc_out)
);

instruction_mem IMEM(
    .addr(pc_out),
    .instr(if_instr)
);


// IF/ID REGISTER

wire [31:0] id_instr;
wire [63:0] id_pc_plus4;  

IF_ID_reg IF_ID(
    .clk(clk),
    .reset(reset),
    .stall(stall_if_id),
    .flush(flush_if_id_sig),
    .ins_in(if_instr), 
    .pc_in(pc_plus4),
    .ins_out(id_instr), 
    .pc_out(id_pc_plus4)
);





// ID STAGE

wire [4:0]  id_rs1    = id_instr[19:15];
wire [4:0]  id_rs2    = id_instr[24:20];
wire [4:0]  id_rd     = id_instr[11:7];
wire [2:0]  id_funct3 = id_instr[14:12];
wire [6:0]  id_funct7 = id_instr[31:25];

wire id_RegWrite, id_MemRead, id_MemWrite, id_Branch, id_ALUSrc, id_MemtoReg;
wire [1:0] id_ALUOp;

control_unit CU(
    .opcode(id_instr[6:0]),
    .RegWrite(id_RegWrite),
    .MemRead(id_MemRead),
    .MemWrite(id_MemWrite),
    .Branch(id_Branch),
    .ALUSrc(id_ALUSrc),
    .MemtoReg(id_MemtoReg),
    .ALUOp(id_ALUOp)
);

wire [63:0] id_read_data1, id_read_data2;

reg_file RF(
    .clk(clk),
    .reset(reset),
    .read_reg1(id_rs1),
    .read_reg2(id_rs2),
    .write_reg(wb_rd),
    .write_data(wb_write_data),
    .reg_write_en(wb_RegWrite),
    .read_data1(id_read_data1),
    .read_data2(id_read_data2) 
);

wire [63:0] id_immediate;

imm_gen IMM(
    .instr(id_instr), 
    .imm_out(id_immediate) 
);

hazard_detection HDU(
    .idex_memread(ex_MemRead), 
    .idex_d(ex_rd),
    .ifid_s1(id_rs1),
    .ifid_s2(id_rs2),
    .stall_pc(stall_pc),
    .stall_ifid(stall_if_id),
    .flush_idex(flush_id_ex)
);


// ID/EX REGISTER

wire ex_RegWrite, ex_MemWrite, ex_ALUSrc, ex_MemtoReg;
wire [1:0]  ex_ALUOp;
wire [63:0] ex_read_data1, ex_read_data2, ex_immediate, ex_pc_plus4;
wire [4:0]  ex_rs1, ex_rs2;
wire [2:0]  ex_funct3;
wire [6:0]  ex_funct7;


ID_EX_reg ID_EX(
    .clk(clk),
    .reset(reset),
    .flush(flush_id_ex_sig),
    .RegWrite_in(id_RegWrite),
    .MemRead_in(id_MemRead),
    .MemWrite_in(id_MemWrite),
    .Branch_in(id_Branch),
    .ALUSrc_in(id_ALUSrc),
    .MemtoReg_in(id_MemtoReg),
    .ALUOp_in(id_ALUOp),
    .s1_data_in(id_read_data1),
    .s2_data_in(id_read_data2),
    .imm_in(id_immediate),
    .pc_in(id_pc_plus4),
    .s1_add_in(id_rs1),
    .s2_add_in(id_rs2),
    .d_add_in(id_rd),
    .id_funct3(id_funct3),
    .id_funct7(id_funct7),

    .RegWrite_out(ex_RegWrite),
    .MemRead_out(ex_MemRead),
    .MemWrite_out(ex_MemWrite),
    .Branch_out(ex_Branch_out),
    .ALUSrc_out(ex_ALUSrc),
    .MemtoReg_out(ex_MemtoReg),
    .ALUOp_out(ex_ALUOp),
    .s1_data_out(ex_read_data1),
    .s2_data_out(ex_read_data2),
    .imm_out(ex_immediate),
    .pc_out(ex_pc_plus4),
    .s1_add_out(ex_rs1),
    .s2_add_out(ex_rs2),
    .d_add_out(ex_rd),
    .ex_funct3(ex_funct3),
    .ex_funct7(ex_funct7)
);


// EX STAGE

wire [1:0] ForwardA, ForwardB;

forwarding_unit FWU(
    .idex_s1(ex_rs1),
    .idex_s2(ex_rs2),
    .exmem_reg_write(mem_RegWrite),
    .exmem_d(mem_rd),
    .memwb_reg_write(wb_RegWrite),
    .memwb_d(wb_rd),
    .cont_A(ForwardA),
    .cont_B(ForwardB)
);

// ALU input A (rs1 with forwarding)
wire [63:0] alu_input_a;
assign alu_input_a = (ForwardA == 2'b10) ? mem_alu_result :
                     (ForwardA == 2'b01) ? wb_write_data  :
                                           ex_read_data1;

// ALU input B (rs2 with forwarding, before ALUSrc mux)
wire [63:0] ex_rs2_forwarded;
assign ex_rs2_forwarded = (ForwardB == 2'b10) ? mem_alu_result :
                          (ForwardB == 2'b01) ? wb_write_data  :
                                                ex_read_data2;

// ALUSrc mux
wire [63:0] alu_input_b;
assign alu_input_b = ex_ALUSrc ? ex_immediate : ex_rs2_forwarded;

wire [3:0] alu_ctrl;
ALU_control ALU_control_copy(
    .ALUOp(ex_ALUOp),
    .funct3(ex_funct3),
    .funct7bit(ex_funct7[5]),
    .ALUControl(alu_ctrl)
);

wire [63:0] ex_alu_result;

alu ALU(
    .a(alu_input_a),
    .b(alu_input_b),
    .opcode(alu_ctrl),
    .result(ex_alu_result),
    .zero_flag(ex_zero)          
);

// Branch target: PC_of_branch + immediate
// ex_pc_plus4 = branch_PC + 4, so branch_PC = ex_pc_plus4 - 4

assign ex_branch_target = (ex_pc_plus4 - 64'd4) + ex_immediate; 




// Store data: forwarded rs2 before ALUSrc mux
wire [63:0] ex_store_data;
assign ex_store_data = ex_rs2_forwarded;


// EX/MEM REGISTER
// mem_branch and mem_zero still stored but not used for branch decision

wire mem_branch_unused, mem_zero_unused;
wire [63:0] mem_branch_target_unused;

EX_MEM_reg EX_MEM(
    .clk(clk),
    .reset(reset),
    .RegWrite_in(ex_RegWrite),
    .MemRead_in(ex_MemRead),
    .MemWrite_in(ex_MemWrite),
    .Branch_in(ex_Branch_out),
    .MemtoReg_in(ex_MemtoReg),
    .alu_res_in(ex_alu_result),
    .s2_data_in(ex_store_data),
    .target_in(ex_branch_target),
    .zero_in(ex_zero),
    .d_add_in(ex_rd),

    .RegWrite_out(mem_RegWrite),
    .MemRead_out(mem_MemRead),
    .MemWrite_out(mem_MemWrite),
    .Branch_out(mem_branch_unused),
    .MemtoReg_out(mem_MemtoReg),
    .alu_res_out(mem_alu_result),
    .s2_data_out(mem_write_data),
    .target_out(mem_branch_target_unused),
    .zero_out(mem_zero_unused),
    .d_add_out(mem_rd)
);

// MEM STAGE

wire [63:0] mem_read_data;

data_mem DMEM(
    .clk(clk),
    .reset(reset),
    .address(mem_alu_result[9:0]),
    .write_data(mem_write_data),
    .MemRead(mem_MemRead),
    .MemWrite(mem_MemWrite),
    .read_data(mem_read_data)
);

// MEM/WB REGISTER

MEM_WB_reg MEM_WB(
    .clk(clk),
    .reset(reset),
    .RegWrite_in(mem_RegWrite),
    .MemtoReg_in(mem_MemtoReg),
    .mem_read_data_in(mem_read_data),
    .alu_res_in(mem_alu_result),
    .d_add_in(mem_rd),
    .RegWrite_out(wb_RegWrite),
    .MemtoReg_out(wb_MemtoReg),
    .mem_read_data_out(wb_read_data),
    .alu_res_out(wb_alu_result),
    .d_add_out(wb_rd)
);


endmodule