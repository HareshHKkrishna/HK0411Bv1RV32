`timescale 1ns/1ns

import cpu_types_pkg::*;

module wb_stage (
    // From MEM/WB
    input  logic [31:0] alu_result_wb,
    input  logic [31:0] mem_read_data_wb,
    input  logic [31:0] imm_wb,
    input  logic [31:0] pc4_wb,
    input  logic [4:0]  rd_addr_wb,
    input  logic        RegWrite_wb,
    input  wb_select_t  WBSelect_wb,

    // To register file
    output logic [4:0]  wr_addr,
    output logic [31:0] wr_data,
    output logic        wr_en
);

    always_comb begin
        wr_addr = rd_addr_wb;
        wr_en   = RegWrite_wb;

        case (WBSelect_wb)
            WB_ALU : wr_data = alu_result_wb;
            WB_MEM : wr_data = mem_read_data_wb;
            WB_PC4 : wr_data = pc4_wb;
            WB_IMM : wr_data = imm_wb;
            default: wr_data = 32'd0;
        endcase
    end

endmodule
