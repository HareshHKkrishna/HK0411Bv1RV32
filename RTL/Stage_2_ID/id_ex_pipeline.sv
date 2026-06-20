`timescale 1ns/1ns
import cpu_types_pkg::*;

module id_ex_pipeline (

    input logic clk,
    input logic rst,
    input logic stall,
    input logic flush,
//data
    input logic [31:0]rs1_data,
    input logic [31:0]rs2_data,
    input logic [31:0]imm,
    input logic [4:0]rd_addr,
    input logic [2:0]func3,
    input logic [4:0]rs1_addr,
    input logic [4:0]rs2_addr,
    input logic [31:0]pc,
    input logic [31:0]pc4,
//control
    input logic RegWrite,
    input logic MemRead,
    input logic MemWrite,
    input logic Branch,
    input logic Jump,
    input logic ALUSrc,
    input wb_select_t WBSelect,
    input logic [3:0]alu_control,


    output logic [31:0]rs1_data_ex,
    output logic [31:0]rs2_data_ex,
    output logic [31:0]imm_ex,
    output logic [4:0]rd_addr_ex,
    output logic [2:0]func3_ex,
    output logic [4:0]rs1_addr_ex,
    output logic [4:0]rs2_addr_ex,
    output logic [31:0]pc_ex,
    output logic [31:0]pc4_ex,
    
//control
    output logic RegWrite_ex,
    output logic MemRead_ex,
    output logic MemWrite_ex,
    output logic Branch_ex,
    output logic Jump_ex,
    output logic ALUSrc_ex,
    output wb_select_t WBSelect_ex,
    output logic [3:0]alu_control_ex
);

always_ff @(posedge clk) begin

    if(rst || flush) begin

        rs1_data_ex <= '0;
        rs2_data_ex <= '0;
        imm_ex      <= '0;

        rd_addr_ex  <= '0;
        func3_ex    <= '0;

        rs1_addr_ex <= '0;
        rs2_addr_ex <= '0;

        pc_ex       <= '0;
        pc4_ex      <= '0;

        RegWrite_ex <= 1'b0;
        MemRead_ex  <= 1'b0;
        MemWrite_ex <= 1'b0;
        Branch_ex   <= 1'b0;
        Jump_ex     <= 1'b0;
        ALUSrc_ex   <= 1'b0;

        WBSelect_ex <= WB_ALU;
        alu_control_ex <= '0;

    end

    else if(!stall) begin

        rs1_data_ex <= rs1_data;
        rs2_data_ex <= rs2_data;
        imm_ex      <= imm;

        rd_addr_ex  <= rd_addr;
        func3_ex    <= func3;

        rs1_addr_ex <= rs1_addr;
        rs2_addr_ex <= rs2_addr;

        pc_ex       <= pc;
        pc4_ex      <= pc4;

        RegWrite_ex <= RegWrite;
        MemRead_ex  <= MemRead;
        MemWrite_ex <= MemWrite;
        Branch_ex   <= Branch;
        Jump_ex     <= Jump;
        ALUSrc_ex   <= ALUSrc;

        WBSelect_ex <= WBSelect;
        alu_control_ex <= alu_control;

    end

end
    
endmodule