`timescale 1ns/1ns

module imm_gen_tb;

    logic [31:0] ir;
    logic [31:0] imm;

    // DUT
    imm_gen dut (
        .ir(ir),
        .imm(imm)
    );

    initial begin

        $display("\n===== IMM_GEN TEST START =====\n");

        //--------------------------------------------------
        // I-Type : ADDI x1,x2,-1
        //--------------------------------------------------
        ir = 32'hFFF10093;   // imm = 12'hFFF = -1
        #1;

        assert(imm == 32'hFFFFFFFF)
        else $error("I-Type FAILED Expected FFFFFFFF Got %h", imm);

        $display("I-Type PASS");

        //--------------------------------------------------
        // S-Type : SW x5,16(x2)
        //--------------------------------------------------
        ir = 32'b0000000_00101_00010_010_10000_0100011;
        #1;

        assert(imm == 32'd16)
        else $error("S-Type FAILED Expected 16 Got %0d", imm);

        $display("S-Type PASS");

        //--------------------------------------------------
        // B-Type : BEQ offset = 8
        //--------------------------------------------------
        ir = 32'b0000000_00010_00001_000_01000_1100011;
        #1;

        $display("B-Type Imm = %0d", $signed(imm));

        //--------------------------------------------------
        // U-Type : LUI x1,0x12345
        //--------------------------------------------------
        ir = 32'h123450B7;
        #1;

        assert(imm == 32'h12345000)
        else $error("U-Type FAILED Expected 12345000 Got %h", imm);

        $display("U-Type PASS");

        //--------------------------------------------------
        // J-Type : JAL offset = 2048
        //--------------------------------------------------
        ir = 32'h001000EF;
        #1;

        $display("J-Type Imm = %0d", $signed(imm));

        //--------------------------------------------------
        // Default Case
        //--------------------------------------------------
        ir = 32'h00000000;
        #1;

        assert(imm == 32'h00000000)
        else $error("DEFAULT FAILED");

        $display("Default PASS");

        //--------------------------------------------------
        // Negative I-Type
        //--------------------------------------------------
        ir = 32'h80000013;   // imm = 0x800 => -2048
        #1;

        assert($signed(imm) == -2048)
        else $error("Negative I-Type FAILED");

        $display("Negative I-Type PASS");

        //--------------------------------------------------
        // Negative B-Type
        //--------------------------------------------------
        ir = 32'hFE000EE3;
        #1;

        $display("Negative B-Type Imm = %0d", $signed(imm));

        $display("\n===== ALL TESTS COMPLETED =====\n");

        #10;
        $finish;

    end

endmodule