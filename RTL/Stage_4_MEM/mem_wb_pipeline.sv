`timescale 1ns/1ns

import cpu_types_pkg::*;

module mem_wb_pipeline (
    input  logic        clk,
    input  logic        rst,
    input  logic        stall,

    // From MEM stage
    input  logic [31:0] alu_result_wb_in,
    input  logic [31:0] mem_read_data_wb_in,
    input  logic [31:0] imm_wb_in,
    input  logic [31:0] pc4_wb_in,
    input  logic [4:0]  rd_addr_wb_in,
    input  logic        RegWrite_wb_in,
    input  wb_select_t  WBSelect_wb_in,

    // To WB stage
    output logic [31:0] alu_result_wb_out,
    output logic [31:0] mem_read_data_wb_out,
    output logic [31:0] imm_wb_out,
    output logic [31:0] pc4_wb_out,
    output logic [4:0]  rd_addr_wb_out,
    output logic        RegWrite_wb_out,
    output wb_select_t  WBSelect_wb_out
);

    always_ff @(posedge clk) begin
        if (rst) begin
            alu_result_wb_out    <= 32'd0;
            mem_read_data_wb_out <= 32'd0;
            imm_wb_out           <= 32'd0;
            pc4_wb_out           <= 32'd0;
            rd_addr_wb_out       <= 5'd0;
            RegWrite_wb_out      <= 1'b0;
            WBSelect_wb_out      <= WB_ALU;
        end
        else if (!stall) begin
            alu_result_wb_out    <= alu_result_wb_in;
            mem_read_data_wb_out <= mem_read_data_wb_in;
            imm_wb_out           <= imm_wb_in;
            pc4_wb_out           <= pc4_wb_in;
            rd_addr_wb_out       <= rd_addr_wb_in;
            RegWrite_wb_out      <= RegWrite_wb_in;
            WBSelect_wb_out      <= WBSelect_wb_in;
        end
    end

endmodule
