`timescale 1ns/1ns

module instruction_decode_tb;

    logic [31:0] ir;

    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic [6:0] opcode;
    logic [2:0] func3;
    logic [6:0] func7;

    instruction_decode dut (
        .ir(ir),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .func3(func3),
        .func7(func7)
    );

    initial begin

        $display("\n===== INSTRUCTION DECODE TEST START =====\n");

        //--------------------------------------------------
        // R-Type : ADD x5,x6,x7
        //--------------------------------------------------
        ir = {7'b0100100,5'd4,5'd2,3'b010,5'd16,7'b0110011};
        #1;

        assert(opcode == 7'b0110011);
        assert(rd     == 4);
        assert(rs1    == 2);
        assert(rs2    == 16);
        assert(func3  == 3'b010);
        assert(func7  == 7'b0100100);

        $display("R-Type PASS");

        //--------------------------------------------------
        // I-Type : ADDI x5,x6,10
        //--------------------------------------------------
        ir = {12'd10,5'd6,3'b000,5'd5,7'b0010011};
        #1;

        assert(opcode == 7'b0010011);
        assert(rd     == 5);
        assert(rs1    == 6);
        assert(rs2    == 0);
        assert(func3  == 3'b000);
        assert(func7  == 0);

        $display("I-Type PASS");

        //--------------------------------------------------
        // LOAD : LW x5,0(x6)
        //--------------------------------------------------
        ir = {12'd0,5'd6,3'b010,5'd5,7'b0000011};
        #1;

        assert(opcode == 7'b0000011);
        assert(rd     == 5);
        assert(rs1    == 6);
        assert(rs2    == 0);
        assert(func3  == 3'b010);

        $display("LOAD PASS");

        //--------------------------------------------------
        // STORE : SW x7,0(x6)
        //--------------------------------------------------
        ir = {7'd0,5'd7,5'd6,3'b010,5'd0,7'b0100011};
        #1;

        assert(opcode == 7'b0100011);
        assert(rd     == 0);
        assert(rs1    == 6);
        assert(rs2    == 7);
        assert(func3  == 3'b010);

        $display("STORE PASS");

        //--------------------------------------------------
        // BRANCH : BEQ x6,x7,label
        //--------------------------------------------------
        ir = {7'd0,5'd7,5'd6,3'b000,5'd0,7'b1100011};
        #1;

        assert(opcode == 7'b1100011);
        assert(rd     == 0);
        assert(rs1    == 6);
        assert(rs2    == 7);
        assert(func3  == 3'b000);

        $display("BRANCH PASS");

        //--------------------------------------------------
        // LUI : LUI x10,imm
        //--------------------------------------------------
        ir = {20'h12345,5'd10,7'b0110111};
        #1;

        assert(opcode == 7'b0110111);
        assert(rd     == 10);
        assert(rs1    == 0);
        assert(rs2    == 0);

        $display("LUI PASS");

        //--------------------------------------------------
        // JAL : JAL x1,label
        //--------------------------------------------------
        ir = 32'h000000EF;
        #1;

        assert(opcode == 7'b1101111);
        assert(rd     == 1);
        assert(rs1    == 0);
        assert(rs2    == 0);

        $display("JAL PASS");

        //--------------------------------------------------
        // DEFAULT
        //--------------------------------------------------
        ir = 32'hFFFFFFFF;
        #1;

        assert(opcode == 7'b1111111);
        assert(rd     == 0);
        assert(rs1    == 0);
        assert(rs2    == 0);
        assert(func3  == 0);
        assert(func7  == 0);

        $display("DEFAULT PASS");

        $display("\n===== ALL TESTS PASSED =====\n");

        #10;
        $finish;

    end

endmodule