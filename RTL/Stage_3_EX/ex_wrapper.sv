import cpu_types_pkg::*;
module ex_wrapper (
    // Memory/Data
    input logic [31:0] rs1_data_ex,
    input logic [31:0] rs2_data_ex,
    input logic [31:0] imm_ex,
    input logic [4:0]  rd_addr_ex,
    input logic [2:0]  func3_ex,
    input logic [4:0]  rs1_addr_ex,
    input logic [4:0]  rs2_addr_ex,
    input logic [31:0] pc_ex,
    input logic [31:0] pc4_ex,

    // Control
    input logic       RegWrite_ex,
    input logic       MemRead_ex,
    input logic       MemWrite_ex,
    input logic       Branch_ex,
    input logic       Jump_ex,
    input logic       ALUSrc_ex,
    input wb_select_t WBSelect_ex,
    input logic [3:0] alu_control_ex,

    // Outputs
    output logic [31:0] alu_result,
    output logic [31:0] pc_next,
    output logic        branch_taken,

    output logic [31:0] rs2_data_mem,
    output logic [4:0]  rd_addr_mem,

    output logic        RegWrite_mem,
    output logic        MemRead_mem,
    output logic        MemWrite_mem,
    output wb_select_t  WBSelect_mem
);

logic [31:0]alu_output;
logic [31:0]operandb;
logic branchtaken;
logic [31:0]pcnext;

alu_mux alu_mux1(.ALUSrc(ALUSrc_ex),.imm(imm_ex),.rs2_data(rs2_data_ex),.Operand_B(operandb));

alu alu1(.a(rs1_data_ex),.b(operandb),.alu_control(alu_control_ex),.result(alu_output));

branch_control_unit branch_control_unit1(.rs1_data(rs1_data_ex),.rs2_data(rs2_data_ex),.func3(func3_ex),.branch(Branch_ex),.branch_taken(branchtaken));

branch_target_gen branch_target_gen1(.imm(imm_ex),.Jump_ex(Jump_ex),.pc(pc_ex),.pc4(pc4_ex),.branch_taken(branchtaken),.pc_next(pcnext));

   //--------------------------------------------------
    assign alu_result   = alu_output;
    assign branch_taken = branchtaken;
    assign pc_next      = pcnext;

    assign rs2_data_mem = rs2_data_ex;
    assign rd_addr_mem  = rd_addr_ex;

    assign RegWrite_mem = RegWrite_ex;
    assign MemRead_mem  = MemRead_ex;
    assign MemWrite_mem = MemWrite_ex;
    assign WBSelect_mem = WBSelect_ex;

endmodule