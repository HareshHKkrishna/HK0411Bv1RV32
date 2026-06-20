`timescale 1ns/1ns

import cpu_types_pkg::*;
module main_control_unit (
    input  logic [6:0] opcode,

    output logic       RegWrite,
    output logic       MemRead,
    output logic       MemWrite,
    output logic       Branch,
    output logic       Jump,
    output logic       ALUSrc,

    output wb_select_t WBSelect,
    output aluop_t     ALUOp
);

    always_comb begin

        // Default values
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        Jump     = 1'b0;
        ALUSrc   = 1'b0;

        WBSelect = WB_ALU;
        ALUOp    = ALUOP_RTYPE;

        case(opcode)

            // R-Type
            7'b0110011: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b0;
                WBSelect = WB_ALU;
                ALUOp    = ALUOP_RTYPE;
            end

            // I-Type Arithmetic
            7'b0010011: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                WBSelect = WB_ALU;
                ALUOp    = ALUOP_ITYPE;
            end

            // LW
            7'b0000011: begin
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                ALUSrc   = 1'b1;
                WBSelect = WB_MEM;
                ALUOp    = ALUOP_LW_SW;
            end

            // SW
            7'b0100011: begin
                MemWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = ALUOP_LW_SW;
            end

            // BEQ / BNE
            7'b1100011: begin
                Branch = 1'b1;
                ALUSrc = 1'b0;
                ALUOp  = ALUOP_BRANCH;
            end

            // JAL
            7'b1101111: begin
                RegWrite = 1'b1;
                Jump     = 1'b1;
                ALUSrc   = 1'b1;
                WBSelect = WB_PC4;
                ALUOp    = ALUOP_JUMP;
            end

            // LUI
            7'b0110111: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                WBSelect = WB_IMM;
                ALUOp    = ALUOP_UPPERIMM;
            end

            default: begin

            end

        endcase
    end

endmodule