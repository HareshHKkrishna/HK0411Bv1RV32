`timescale 1ns/1ns

import cpu_types_pkg::*;

module mem_stage (
    // From EX/MEM
    input  logic [31:0] alu_result_mem_in,
    input  logic [31:0] rs2_data_mem_in,
    input  logic [31:0] imm_mem_in,
    input  logic [31:0] pc4_mem_in,
    input  logic [4:0]  rd_addr_mem_in,
    input  logic        RegWrite_mem_in,
    input  logic        MemWrite_mem_in,
    input  wb_select_t  WBSelect_mem_in,

    // External data memory interface
    output logic [31:0] data_addr,
    output logic [31:0] data_wdata,
    output logic        data_we,
    input  logic [31:0] data_rdata,

    // To MEM/WB
    output logic [31:0] mem_read_data_mem_out,
    output logic [31:0] alu_result_wb_out,
    output logic [31:0] imm_wb_out,
    output logic [31:0] pc4_wb_out,
    output logic [4:0]  rd_addr_wb_out,
    output logic        RegWrite_wb_out,
    output wb_select_t  WBSelect_wb_out
);

    assign data_addr  = alu_result_mem_in;
    assign data_wdata = rs2_data_mem_in;
    assign data_we    = MemWrite_mem_in;

    always_comb begin
        // The actual data memory lives outside the MEM stage.
        // The MEM stage only adapts pipeline signals to the external bus.
        mem_read_data_mem_out = data_rdata;
        alu_result_wb_out     = alu_result_mem_in;
        imm_wb_out            = imm_mem_in;
        pc4_wb_out            = pc4_mem_in;
        rd_addr_wb_out        = rd_addr_mem_in;
        RegWrite_wb_out       = RegWrite_mem_in;
        WBSelect_wb_out       = WBSelect_mem_in;
    end

endmodule
