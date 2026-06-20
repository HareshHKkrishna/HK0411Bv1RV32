/*typedef enum logic [1:0]{
    WB_ALU,
    WB_MEM,
    WB_PC4,
    WB_IMM
} wb_select_t;

typedef enum logic [2:0]{
    ALUOP_LW_SW,
    ALUOP_BRANCH,
    ALUOP_RTYPE,
    ALUOP_ITYPE,
    ALUOP_UPPERIMM,
    ALUOP_JUMP
} aluop_t;


*/
import cpu_types_pkg::*;
`timescale 1ns/1ns
module id_stage (
    input logic [31:0]instr,
    input logic clk,
    input logic rst,
    input logic [4:0]wr_addr,
    input logic [31:0]wr_data,
    input logic wr_en,

    output logic [31:0]rs1_data,
    output logic [31:0]rs2_data,
    output logic [31:0]imm,
    output logic [4:0]rd_addr,
    output logic [2:0]func3,
    output logic [4:0]rs1_addr,
    output logic [4:0]rs2_addr,

    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic Branch,
    output logic Jump,
    output logic ALUSrc,
    output wb_select_t WBSelect,
    output logic [3:0]alu_control
);

logic [6:0]  opcode;
logic [2:0] func3_int;
logic [6:0]  func7;
aluop_t ALUOp;


instruction_decode instruction_decoder(.ir(instr),.rs1(rs1_addr),.rs2(rs2_addr),.rd(rd_addr),.opcode(opcode),.func3(func3_int),.func7(func7));
imm_gen immediate_generator(.ir(instr),.imm(imm));
main_control_unit main_control_unit1(.opcode(opcode),.RegWrite(RegWrite),.MemRead(MemRead),.MemWrite(MemWrite),.Branch(Branch),.Jump(Jump),.ALUSrc(ALUSrc),.WBSelect(WBSelect),.ALUOp(ALUOp));
alu_control alu_control1(.ALUOp(ALUOp),.func3(func3_int),.func7(func7),.alu_control(alu_control));
reg_file reg_file1(.rs1(rs1_addr),.rs2(rs2_addr),.wr_addr(wr_addr),.wr_data(wr_data),.wr_en(wr_en),.clk(clk),.rst(rst),.rs1_data(rs1_data),.rs2_data(rs2_data));
assign func3 = func3_int;
endmodule