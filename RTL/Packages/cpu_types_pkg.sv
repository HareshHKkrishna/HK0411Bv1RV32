`timescale 1ns/1ns
package cpu_types_pkg;

typedef enum logic [1:0]{
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

endpackage
