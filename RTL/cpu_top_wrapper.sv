`timescale 1ns/1ns

import cpu_types_pkg::*;

module cpu_top_wrapper (
    input  logic        clk,
    input  logic        rst,

    // Useful debug outputs
    output logic [31:0] instr_addr,
    output logic [31:0] pc_out,
    output logic [31:0] pc4_out,
    output logic [31:0] instr_out,

    output logic [31:0] data_addr,
    output logic [31:0] data_wdata,
    output logic        data_we,

    output logic [4:0]  wr_addr,
    output logic [31:0] wr_data,
    output logic        wr_en
);

    //-------------------------------------------------------------------------
    // Control
    //-------------------------------------------------------------------------
    logic stall_if;
    logic stall_pipe;
    logic flush_redirect;

    assign stall_if   = 1'b0;
    assign stall_pipe = 1'b0;

    //-------------------------------------------------------------------------
    // Instruction fetch
    //-------------------------------------------------------------------------
    logic [31:0] instr_fetch;
    logic [31:0] pc_ifid;
    logic [31:0] pc4_ifid;
    logic [31:0] pc_next;

    //-------------------------------------------------------------------------
    // Decode stage
    //-------------------------------------------------------------------------
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] imm;
    logic [4:0]  rd_addr;
    logic [2:0]  func3;
    logic [4:0]  rs1_addr;
    logic [4:0]  rs2_addr;

    logic RegWrite;
    logic MemRead;
    logic MemWrite;
    logic Branch;
    logic Jump;
    logic ALUSrc;
    wb_select_t WBSelect;
    logic [3:0] alu_control;

    //-------------------------------------------------------------------------
    // ID/EX
    //-------------------------------------------------------------------------
    logic [31:0] rs1_data_ex;
    logic [31:0] rs2_data_ex;
    logic [31:0] imm_ex;
    logic [4:0]  rd_addr_ex;
    logic [2:0]  func3_ex;
    logic [4:0]  rs1_addr_ex;
    logic [4:0]  rs2_addr_ex;
    logic [31:0] pc_ex;
    logic [31:0] pc4_ex;
    logic        RegWrite_ex;
    logic        MemRead_ex;
    logic        MemWrite_ex;
    logic        Branch_ex;
    logic        Jump_ex;
    logic        ALUSrc_ex;
    wb_select_t  WBSelect_ex;
    logic [3:0]  alu_control_ex;

    //-------------------------------------------------------------------------
    // EX stage
    //-------------------------------------------------------------------------
    logic [31:0] alu_result;
    logic        branch_taken;
    logic [31:0] rs2_data_mem;
    logic [31:0] imm_mem;
    logic [31:0] pc4_mem;
    logic [4:0]  rd_addr_mem;
    logic        RegWrite_mem;
    logic        MemRead_mem;
    logic        MemWrite_mem;
    wb_select_t  WBSelect_mem;

    //-------------------------------------------------------------------------
    // EX/MEM
    //-------------------------------------------------------------------------
    logic [31:0] alu_result_mem;
    logic [31:0] rs2_data_mem_pipe;
    logic [31:0] imm_mem_pipe;
    logic [31:0] pc4_mem_pipe;
    logic [4:0]  rd_addr_mem_pipe;
    logic        RegWrite_mem_pipe;
    logic        MemRead_mem_pipe;
    logic        MemWrite_mem_pipe;
    wb_select_t  WBSelect_mem_pipe;

    //-------------------------------------------------------------------------
    // MEM stage
    //-------------------------------------------------------------------------
    logic [31:0] data_rdata;
    logic [31:0] mem_read_data_mem;
    logic [31:0] alu_result_wb;
    logic [31:0] imm_wb;
    logic [31:0] pc4_wb;
    logic [4:0]  rd_addr_wb;
    logic        RegWrite_wb;
    wb_select_t  WBSelect_wb;

    //-------------------------------------------------------------------------
    // MEM/WB
    //-------------------------------------------------------------------------
    logic [31:0] alu_result_wb_pipe;
    logic [31:0] mem_read_data_wb_pipe;
    logic [31:0] imm_wb_pipe;
    logic [31:0] pc4_wb_pipe;
    logic [4:0]  rd_addr_wb_pipe;
    logic        RegWrite_wb_pipe;
    wb_select_t  WBSelect_wb_pipe;

    // Flush taken branches and jumps.
    assign flush_redirect = branch_taken | Jump_ex;

    //-------------------------------------------------------------------------
    // Instruction memory
    //-------------------------------------------------------------------------
    instruction_memory instruction_memory1 (
        .pc   (instr_addr),
        .instr(instr_fetch)
    );

    //-------------------------------------------------------------------------
    // IF stage
    //-------------------------------------------------------------------------
    if_stage if_stage1 (
        .clk       (clk),
        .rst       (rst),
        .stall     (stall_if),
        .flush     (flush_redirect),
        .pc_next   (pc_next),
        .instr_addr(instr_addr),
        .instr_data(instr_fetch),
        .instr_out (instr_out),
        .pc_out    (pc_out),
        .pc4_out   (pc4_out)
    );

    //-------------------------------------------------------------------------
    // ID stage
    //-------------------------------------------------------------------------
    id_stage id_stage1 (
        .instr     (instr_out),
        .clk       (clk),
        .rst       (rst),
        .wr_addr   (wr_addr),
        .wr_data   (wr_data),
        .wr_en     (wr_en),
        .rs1_data  (rs1_data),
        .rs2_data  (rs2_data),
        .imm       (imm),
        .rd_addr   (rd_addr),
        .func3     (func3),
        .rs1_addr  (rs1_addr),
        .rs2_addr  (rs2_addr),
        .RegWrite  (RegWrite),
        .MemRead   (MemRead),
        .MemWrite  (MemWrite),
        .Branch    (Branch),
        .Jump      (Jump),
        .ALUSrc    (ALUSrc),
        .WBSelect  (WBSelect),
        .alu_control(alu_control)
    );

    //-------------------------------------------------------------------------
    // ID/EX pipeline register
    //-------------------------------------------------------------------------
    id_ex_pipeline id_ex_pipeline1 (
        .clk          (clk),
        .rst          (rst),
        .stall        (stall_pipe),
        .flush        (flush_redirect),
        .rs1_data     (rs1_data),
        .rs2_data     (rs2_data),
        .imm          (imm),
        .rd_addr      (rd_addr),
        .func3        (func3),
        .rs1_addr     (rs1_addr),
        .rs2_addr     (rs2_addr),
        .pc           (pc_out),
        .pc4          (pc4_out),
        .RegWrite     (RegWrite),
        .MemRead      (MemRead),
        .MemWrite     (MemWrite),
        .Branch       (Branch),
        .Jump         (Jump),
        .ALUSrc       (ALUSrc),
        .WBSelect     (WBSelect),
        .alu_control  (alu_control),
        .rs1_data_ex  (rs1_data_ex),
        .rs2_data_ex  (rs2_data_ex),
        .imm_ex       (imm_ex),
        .rd_addr_ex   (rd_addr_ex),
        .func3_ex     (func3_ex),
        .rs1_addr_ex  (rs1_addr_ex),
        .rs2_addr_ex  (rs2_addr_ex),
        .pc_ex        (pc_ex),
        .pc4_ex       (pc4_ex),
        .RegWrite_ex  (RegWrite_ex),
        .MemRead_ex   (MemRead_ex),
        .MemWrite_ex  (MemWrite_ex),
        .Branch_ex    (Branch_ex),
        .Jump_ex      (Jump_ex),
        .ALUSrc_ex    (ALUSrc_ex),
        .WBSelect_ex  (WBSelect_ex),
        .alu_control_ex(alu_control_ex)
    );

    //-------------------------------------------------------------------------
    // EX stage
    //-------------------------------------------------------------------------
    ex_wrapper ex_wrapper1 (
        .rs1_data_ex (rs1_data_ex),
        .rs2_data_ex (rs2_data_ex),
        .imm_ex      (imm_ex),
        .rd_addr_ex  (rd_addr_ex),
        .func3_ex    (func3_ex),
        .rs1_addr_ex (rs1_addr_ex),
        .rs2_addr_ex (rs2_addr_ex),
        .pc_ex       (pc_ex),
        .pc4_ex      (pc4_ex),
        .RegWrite_ex (RegWrite_ex),
        .MemRead_ex  (MemRead_ex),
        .MemWrite_ex (MemWrite_ex),
        .Branch_ex   (Branch_ex),
        .Jump_ex     (Jump_ex),
        .ALUSrc_ex   (ALUSrc_ex),
        .WBSelect_ex (WBSelect_ex),
        .alu_control_ex(alu_control_ex),
        .alu_result  (alu_result),
        .pc_next     (pc_next),
        .branch_taken(branch_taken),
        .rs2_data_mem(rs2_data_mem),
        .imm_mem     (imm_mem),
        .pc4_mem     (pc4_mem),
        .rd_addr_mem (rd_addr_mem),
        .RegWrite_mem(RegWrite_mem),
        .MemRead_mem (MemRead_mem),
        .MemWrite_mem(MemWrite_mem),
        .WBSelect_mem(WBSelect_mem)
    );

    //-------------------------------------------------------------------------
    // EX/MEM pipeline register
    //-------------------------------------------------------------------------
    ex_mem_pipeline ex_mem_pipeline1 (
        .clk             (clk),
        .rst             (rst),
        .stall           (stall_pipe),
        .alu_result      (alu_result),
        .rs2_data_mem    (rs2_data_mem),
        .imm_mem         (imm_mem),
        .pc4_mem         (pc4_mem),
        .rd_addr_mem     (rd_addr_mem),
        .RegWrite_mem    (RegWrite_mem),
        .MemRead_mem     (MemRead_mem),
        .MemWrite_mem    (MemWrite_mem),
        .WBSelect_mem    (WBSelect_mem),
        .alu_result_mem_out(alu_result_mem),
        .rs2_data_mem_out(rs2_data_mem_pipe),
        .imm_mem_out     (imm_mem_pipe),
        .pc4_mem_out     (pc4_mem_pipe),
        .rd_addr_mem_out (rd_addr_mem_pipe),
        .RegWrite_mem_out(RegWrite_mem_pipe),
        .MemRead_mem_out (MemRead_mem_pipe),
        .MemWrite_mem_out(MemWrite_mem_pipe),
        .WBSelect_mem_out(WBSelect_mem_pipe)
    );

    //-------------------------------------------------------------------------
    // External data memory
    //-------------------------------------------------------------------------
    mem_stage mem_stage1 (
        .alu_result_mem_in(alu_result_mem),
        .rs2_data_mem_in  (rs2_data_mem_pipe),
        .imm_mem_in       (imm_mem_pipe),
        .pc4_mem_in       (pc4_mem_pipe),
        .rd_addr_mem_in   (rd_addr_mem_pipe),
        .RegWrite_mem_in  (RegWrite_mem_pipe),
        .MemWrite_mem_in  (MemWrite_mem_pipe),
        .WBSelect_mem_in  (WBSelect_mem_pipe),
        .data_addr        (data_addr),
        .data_wdata       (data_wdata),
        .data_we          (data_we),
        .data_rdata       (data_rdata),
        .mem_read_data_mem_out(mem_read_data_mem),
        .alu_result_wb_out(alu_result_wb),
        .imm_wb_out       (imm_wb),
        .pc4_wb_out       (pc4_wb),
        .rd_addr_wb_out   (rd_addr_wb),
        .RegWrite_wb_out  (RegWrite_wb),
        .WBSelect_wb_out  (WBSelect_wb)
    );

    data_memory data_memory1 (
        .clk  (clk),
        .addr (data_addr),
        .wdata(data_wdata),
        .we   (data_we),
        .rdata(data_rdata)
    );

    //-------------------------------------------------------------------------
    // MEM/WB pipeline register
    //-------------------------------------------------------------------------
    mem_wb_pipeline mem_wb_pipeline1 (
        .clk                (clk),
        .rst                (rst),
        .stall              (stall_pipe),
        .alu_result_wb_in   (alu_result_wb),
        .mem_read_data_wb_in(mem_read_data_mem),
        .imm_wb_in          (imm_wb),
        .pc4_wb_in          (pc4_wb),
        .rd_addr_wb_in      (rd_addr_wb),
        .RegWrite_wb_in     (RegWrite_wb),
        .WBSelect_wb_in     (WBSelect_wb),
        .alu_result_wb_out  (alu_result_wb_pipe),
        .mem_read_data_wb_out(mem_read_data_wb_pipe),
        .imm_wb_out         (imm_wb_pipe),
        .pc4_wb_out         (pc4_wb_pipe),
        .rd_addr_wb_out     (rd_addr_wb_pipe),
        .RegWrite_wb_out    (RegWrite_wb_pipe),
        .WBSelect_wb_out    (WBSelect_wb_pipe)
    );

    //-------------------------------------------------------------------------
    // WB stage
    //-------------------------------------------------------------------------
    wb_stage wb_stage1 (
        .alu_result_wb    (alu_result_wb_pipe),
        .mem_read_data_wb  (mem_read_data_wb_pipe),
        .imm_wb           (imm_wb_pipe),
        .pc4_wb           (pc4_wb_pipe),
        .rd_addr_wb       (rd_addr_wb_pipe),
        .RegWrite_wb      (RegWrite_wb_pipe),
        .WBSelect_wb      (WBSelect_wb_pipe),
        .wr_addr          (wr_addr),
        .wr_data          (wr_data),
        .wr_en            (wr_en)
    );

endmodule
