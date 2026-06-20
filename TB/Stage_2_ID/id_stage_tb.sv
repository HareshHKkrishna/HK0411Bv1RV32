`timescale 1ns/1ns
module id_stage_tb;

    logic [31:0] instr;
    logic clk;
    logic rst;

    logic [4:0]  wr_addr;
    logic [31:0] wr_data;
    logic        wr_en;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] imm;

    logic [4:0] rd_addr;
    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;

    logic [2:0] func3;

    logic RegWrite;
    logic MemRead;
    logic MemWrite;
    logic Branch;
    logic Jump;
    logic ALUSrc;

    wb_select_t WBSelect;
    logic [3:0] alu_control;

    id_stage dut(
        .*
    );

    always #5 clk = ~clk;
/*
    initial begin

        clk = 1;
        rst = 1;

        wr_en   = 0;
        wr_addr = 0;
        wr_data = 0;
        instr = 32'b0000000010000101000000110110011;
        #10;
        rst = 0;
        wr_en   = 1;

        @(posedge clk);
        //-------------------------------------------------
        // Write x1 = 100
        //-------------------------------------------------
        
        wr_addr = 5'd5;
        wr_data = 32'd100;

       @(posedge clk);

        //-------------------------------------------------
        // Write x2 = 200
        //-------------------------------------------------
        wr_addr = 5'd4;
        wr_data = 32'd200;

        #10;
        @(posedge clk);

        wr_en = 0;

        //-------------------------------------------------
        // ADD x3,x5,x4
        //-------------------------------------------------
        
        #1;

if(rd_addr != 5'd3)
    $fatal("FAIL: rd_addr expected 3 got %0d", rd_addr);

if(rs1_addr != 5'd5)
    $fatal("FAIL: rs1_addr expected 5 got %0d", rs1_addr);

if(rs2_addr != 5'd4)
    $fatal("FAIL: rs2_addr expected 4 got %0d", rs2_addr);

// Register File checks
if(rs1_data != 32'd100)
    $fatal("FAIL: rs1_data expected 100 got %0d", rs1_data);

if(rs2_data != 32'd200)
    $fatal("FAIL: rs2_data expected 200 got %0d", rs2_data);

// Main Control Unit checks
if(RegWrite != 1'b1)
    $fatal("FAIL: RegWrite incorrect");

if(MemRead != 1'b0)
    $fatal("FAIL: MemRead incorrect");

if(MemWrite != 1'b0)
    $fatal("FAIL: MemWrite incorrect");

if(Branch != 1'b0)
    $fatal("FAIL: Branch incorrect");

if(Jump != 1'b0)
    $fatal("FAIL: Jump incorrect");

if(ALUSrc != 1'b0)
    $fatal("FAIL: ALUSrc incorrect");

if(WBSelect != WB_ALU)
    $fatal("FAIL: WBSelect incorrect");

// ALU Control checks
if(alu_control != 4'b0000)
    $fatal("FAIL: alu_control expected ADD (0000), got %b",
            alu_control);

$display("=================================");
$display("ADD TEST PASSED");
$display("=================================");

#20;
$finish;

    end
*/

task automatic check_mem(
    input [31:0] instruction,
    input logic exp_MemRead,
    input logic exp_MemWrite,
    input string instr_name
);
begin

    instr = instruction;
    #1;

    if(rs1_addr != 5'd1)
        $fatal("%s : rs1 mismatch", instr_name);

    if(ALUSrc != 1'b1)
        $fatal("%s : ALUSrc mismatch", instr_name);

    if(alu_control != 4'b0000)
        $fatal("%s : alu_control mismatch", instr_name);

    if(MemRead != exp_MemRead)
        $fatal("%s : MemRead mismatch", instr_name);

    if(MemWrite != exp_MemWrite)
        $fatal("%s : MemWrite mismatch", instr_name);

    $display("%s PASSED", instr_name);

end
endtask

task automatic check_branch(
    input [31:0] instruction,
    input [3:0] expected_alu_control,
    input string instr_name
);
begin

    instr = instruction;
    #1;

    if(Branch != 1'b1)
        $fatal("%s : Branch mismatch", instr_name);

    if(ALUSrc != 1'b0)
        $fatal("%s : ALUSrc mismatch", instr_name);

    if(alu_control != expected_alu_control)
        $fatal("%s : ALU Control mismatch", instr_name);

    $display("%s PASSED", instr_name);

end
endtask
task automatic check_lui(
    input [31:0] instruction
);
begin

    instr = instruction;
    #1;

    if(RegWrite != 1)
        $fatal("LUI RegWrite mismatch");

    if(WBSelect != WB_IMM)
        $fatal("LUI WBSelect mismatch");

    if(alu_control != 4'b1010)
        $fatal("LUI alu_control mismatch");

    $display("LUI PASSED");

end
endtask
task automatic check_jal(
    input [31:0] instruction
);
begin

    instr = instruction;
    #1;

    if(RegWrite != 1)
        $fatal("JAL RegWrite mismatch");

    if(Jump != 1)
        $fatal("JAL Jump mismatch");

    if(WBSelect != WB_PC4)
        $fatal("JAL WBSelect mismatch");

    $display("JAL PASSED");

end
endtask

task automatic check_instruction(
    input [31:0] instruction,
    input [4:0] exp_rd,
    input [4:0] exp_rs1,
    input [4:0] exp_rs2,
    input [3:0] exp_alu_control,
    input logic exp_RegWrite,
    input logic exp_MemRead,
    input logic exp_MemWrite,
    input logic exp_Branch,
    input logic exp_Jump,
    input logic exp_ALUSrc
);
begin

    instr = instruction;
    #1;

    if(rd_addr != exp_rd)
        $fatal("RD mismatch. Expected=%0d Got=%0d", exp_rd, rd_addr);

    if(rs1_addr != exp_rs1)
        $fatal("RS1 mismatch. Expected=%0d Got=%0d", exp_rs1, rs1_addr);

    if(rs2_addr != exp_rs2)
        $fatal("RS2 mismatch. Expected=%0d Got=%0d", exp_rs2, rs2_addr);

    if(alu_control != exp_alu_control)
        $fatal("ALU Control mismatch. Expected=%b Got=%b",
                exp_alu_control, alu_control);

    if(RegWrite != exp_RegWrite)
        $fatal("RegWrite mismatch");

    if(MemRead != exp_MemRead)
        $fatal("MemRead mismatch");

    if(MemWrite != exp_MemWrite)
        $fatal("MemWrite mismatch");

    if(Branch != exp_Branch)
        $fatal("Branch mismatch");

    if(Jump != exp_Jump)
        $fatal("Jump mismatch");

    if(ALUSrc != exp_ALUSrc)
        $fatal("ALUSrc mismatch");

end

endtask

task automatic check_itype(
    input [31:0] instruction,
    input [3:0] expected_alu_control,
    input string instr_name
);
begin

    instr = instruction;
    #1;

    if(rd_addr != 5'd5)
        $fatal("%s : RD mismatch", instr_name);

    if(rs1_addr != 5'd1)
        $fatal("%s : RS1 mismatch", instr_name);

    if(RegWrite != 1'b1)
        $fatal("%s : RegWrite mismatch", instr_name);

    if(MemRead != 1'b0)
        $fatal("%s : MemRead mismatch", instr_name);

    if(MemWrite != 1'b0)
        $fatal("%s : MemWrite mismatch", instr_name);

    if(Branch != 1'b0)
        $fatal("%s : Branch mismatch", instr_name);

    if(Jump != 1'b0)
        $fatal("%s : Jump mismatch", instr_name);

    if(ALUSrc != 1'b1)
        $fatal("%s : ALUSrc mismatch", instr_name);

    if(WBSelect != WB_ALU)
        $fatal("%s : WBSelect mismatch", instr_name);

    if(alu_control != expected_alu_control)
        $fatal("%s : ALU Control mismatch", instr_name);

    $display("%s PASSED", instr_name);

end
endtask
    initial begin

        clk = 1;
        rst = 1;

        wr_en   = 0;
        wr_addr = 0;
        wr_data = 0;
        instr = 32'b0000000010000101000000110110011;
        #10;
        rst = 0;
        wr_en   = 1;

        @(posedge clk);
        //-------------------------------------------------
        // Write x1 = 100
        //-------------------------------------------------
        
        wr_addr = 5'd5;
        wr_data = 32'd100;

       @(posedge clk);

        //-------------------------------------------------
        // Write x2 = 200
        //-------------------------------------------------
        wr_addr = 5'd4;
        wr_data = 32'd200;

        #10;
        @(posedge clk);

        wr_en = 0;
        //----------------------------------------------------
// ADD
//----------------------------------------------------
check_instruction(
    32'h004281B3,   // ADD x3,x5,x4
    5'd3,
    5'd5,
    5'd4,
    4'b0000,
    1,0,0,0,0,0
);

if(rs1_data != 32'd100)
    $fatal("ADD rs1_data failed");

if(rs2_data != 32'd200)
    $fatal("ADD rs2_data failed");

$display("ADD PASSED");

//----------------------------------------------------
// SUB
//----------------------------------------------------
check_instruction(
    32'h404281B3,
    5'd3,
    5'd5,
    5'd4,
    4'b0001,
    1,0,0,0,0,0
);

$display("SUB PASSED");

//----------------------------------------------------
// SLL
//----------------------------------------------------
check_instruction(
    32'h004291B3,
    5'd3,
    5'd5,
    5'd4,
    4'b0010,
    1,0,0,0,0,0
);

$display("SLL PASSED");

//----------------------------------------------------
// SLT
//----------------------------------------------------
check_instruction(
    32'h0042A1B3,
    5'd3,
    5'd5,
    5'd4,
    4'b0011,
    1,0,0,0,0,0
);

$display("SLT PASSED");

//----------------------------------------------------
// SLTU
//----------------------------------------------------
check_instruction(
    32'h0042B1B3,
    5'd3,
    5'd5,
    5'd4,
    4'b0100,
    1,0,0,0,0,0
);

$display("SLTU PASSED");

//----------------------------------------------------
// XOR
//----------------------------------------------------
check_instruction(
    32'h0042C1B3,
    5'd3,
    5'd5,
    5'd4,
    4'b0101,
    1,0,0,0,0,0
);

$display("XOR PASSED");

//----------------------------------------------------
// SRL
//----------------------------------------------------
check_instruction(
    32'h0042D1B3,
    5'd3,
    5'd5,
    5'd4,
    4'b0110,
    1,0,0,0,0,0
);

$display("SRL PASSED");

//----------------------------------------------------
// SRA
//----------------------------------------------------
check_instruction(
    32'h4042D1B3,
    5'd3,
    5'd5,
    5'd4,
    4'b0111,
    1,0,0,0,0,0
);

$display("SRA PASSED");

//----------------------------------------------------
// OR
//----------------------------------------------------
check_instruction(
    32'h0042E1B3,
    5'd3,
    5'd5,
    5'd4,
    4'b1000,
    1,0,0,0,0,0
);

$display("OR PASSED");

//----------------------------------------------------
// AND
//----------------------------------------------------
check_instruction(
    32'h0042F1B3,
    5'd3,
    5'd5,
    5'd4,
    4'b1001,
    1,0,0,0,0,0
);

$display("AND PASSED");



#20;

//--------------------------------------------------
// Write x1 = 50 for I-Type tests
//--------------------------------------------------

wr_en   = 1;
wr_addr = 5'd1;
wr_data = 32'd50;

@(posedge clk);

wr_en = 0;

//--------------------------------------------------
// I-TYPE TESTS
//--------------------------------------------------

check_itype(
    32'h00A08293,
    4'b0000,
    "ADDI"
);

check_itype(
    32'h00A0A293,
    4'b0011,
    "SLTI"
);

check_itype(
    32'h00A0B293,
    4'b0100,
    "SLTIU"
);

check_itype(
    32'h00A0C293,
    4'b0101,
    "XORI"
);

check_itype(
    32'h00A0E293,
    4'b1000,
    "ORI"
);

check_itype(
    32'h00A0F293,
    4'b1001,
    "ANDI"
);

check_itype(
    32'h00409293,
    4'b0010,
    "SLLI"
);

check_itype(
    32'h0040D293,
    4'b0110,
    "SRLI"
);

check_itype(
    32'h4040D293,
    4'b0111,
    "SRAI"
);


check_mem(
    32'h0000A283,    // LW x5,0(x1)
    1'b1,
    1'b0,
    "LW"
);
check_mem(
    32'h0050A023,    // SW x5,0(x1)
    1'b0,
    1'b1,
    "SW"
);
check_branch(
    32'h00208063,
    4'b0001,
    "BEQ"
);
check_branch(
    32'h00209063,
    4'b0001,
    "BNE"
);
check_lui(
    32'h123452B7
);
check_jal(
    32'h000002EF
);
$display("==================================");
$display("ALL R-TYPE TESTS PASSED");
$display("==================================");
$display("====================================");
$display(" ALL I-TYPE TESTS PASSED ");
$display("====================================");
$display("====================================");
$display(" LOAD/STORE TESTS PASSED ");
$display("====================================");

$display("====================================");
$display(" BRANCH TESTS PASSED ");
$display("====================================");

$display("====================================");
$display(" LUI TEST PASSED ");
$display("====================================");

$display("====================================");
$display(" JAL TEST PASSED ");
$display("====================================");

$display("====================================");
$display(" ALL ID STAGE TESTS PASSED ");
$display("====================================");

$finish;
    end
endmodule