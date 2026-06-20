`timescale 1ns/1ns

module main_control_unit_tb;

    logic [6:0] opcode;

    logic       RegWrite;
    logic       MemRead;
    logic       MemWrite;
    logic       Branch;
    logic       Jump;
    logic       ALUSrc;

    wb_select_t WBSelect;
    aluop_t     ALUOp;

    // DUT
    main_control_unit dut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .ALUSrc(ALUSrc),
        .WBSelect(WBSelect),
        .ALUOp(ALUOp)
    );

    initial begin

        $display("\n===== MAIN CONTROL UNIT TEST START =====\n");

        //--------------------------------------------------
        // R-Type
        //--------------------------------------------------
        opcode = 7'b0110011;
        #1;

        assert(RegWrite == 1);
        assert(MemRead  == 0);
        assert(MemWrite == 0);
        assert(Branch   == 0);
        assert(Jump     == 0);
        assert(ALUSrc   == 0);
        assert(WBSelect == WB_ALU);
        assert(ALUOp    == ALUOP_RTYPE);

        $display("R-Type PASS");

        //--------------------------------------------------
        // I-Type
        //--------------------------------------------------
        opcode = 7'b0010011;
        #1;

        assert(RegWrite == 1);
        assert(ALUSrc   == 1);
        assert(WBSelect == WB_ALU);
        assert(ALUOp    == ALUOP_ITYPE);

        $display("I-Type PASS");

        //--------------------------------------------------
        // LW
        //--------------------------------------------------
        opcode = 7'b0000011;
        #1;

        assert(RegWrite == 1);
        assert(MemRead  == 1);
        assert(MemWrite == 0);
        assert(ALUSrc   == 1);
        assert(WBSelect == WB_MEM);
        assert(ALUOp    == ALUOP_LW_SW);

        $display("LW PASS");

        //--------------------------------------------------
        // SW
        //--------------------------------------------------
        opcode = 7'b0100011;
        #1;

        assert(RegWrite == 0);
        assert(MemRead  == 0);
        assert(MemWrite == 1);
        assert(ALUSrc   == 1);
        assert(ALUOp    == ALUOP_LW_SW);

        $display("SW PASS");

        //--------------------------------------------------
        // BRANCH
        //--------------------------------------------------
        opcode = 7'b1100011;
        #1;

        assert(RegWrite == 0);
        assert(Branch   == 1);
        assert(ALUSrc   == 0);
        assert(ALUOp    == ALUOP_BRANCH);

        $display("BRANCH PASS");

        //--------------------------------------------------
        // JAL
        //--------------------------------------------------
        opcode = 7'b1101111;
        #1;

        assert(RegWrite == 1);
        assert(Jump     == 1);
        assert(ALUSrc   == 1);
        assert(WBSelect == WB_PC4);
        assert(ALUOp    == ALUOP_JUMP);

        $display("JAL PASS");

        //--------------------------------------------------
        // LUI
        //--------------------------------------------------
        opcode = 7'b0110111;
        #1;

        assert(RegWrite == 1);
        assert(ALUSrc   == 1);
        assert(WBSelect == WB_IMM);
        assert(ALUOp    == ALUOP_UPPERIMM);

        $display("LUI PASS");

        //--------------------------------------------------
        // DEFAULT
        //--------------------------------------------------
        opcode = 7'b1111111;
        #1;

        assert(RegWrite == 0);
        assert(MemRead  == 0);
        assert(MemWrite == 0);
        assert(Branch   == 0);
        assert(Jump     == 0);
        assert(ALUSrc   == 0);

        $display("DEFAULT PASS");

        $display("\n===== ALL TESTS PASSED =====\n");

        #10;
        $finish;

    end

endmodule