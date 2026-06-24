`timescale 1ns/1ns

import cpu_types_pkg::*;

module cpu_top_wrapper_tb;

    logic clk;
    logic rst;

    logic [31:0] instr_addr;
    logic [31:0] pc_out;
    logic [31:0] pc4_out;
    logic [31:0] instr_out;

    logic [31:0] data_addr;
    logic [31:0] data_wdata;
    logic        data_we;

    logic [4:0]  wr_addr;
    logic [31:0] wr_data;
    logic        wr_en;

    cpu_top_wrapper dut (
        .clk       (clk),
        .rst       (rst),
        .instr_addr(instr_addr),
        .pc_out    (pc_out),
        .pc4_out   (pc4_out),
        .instr_out (instr_out),
        .data_addr (data_addr),
        .data_wdata(data_wdata),
        .data_we   (data_we),
        .wr_addr   (wr_addr),
        .wr_data   (wr_data),
        .wr_en     (wr_en)
    );

    always #5 clk = ~clk;

    function automatic logic [31:0] enc_nop();
        return 32'h0000_0013;
    endfunction

    function automatic logic [31:0] enc_rtype(
        input logic [6:0] funct7,
        input logic [4:0] rs2,
        input logic [4:0] rs1,
        input logic [2:0] funct3,
        input logic [4:0] rd
    );
        return {funct7, rs2, rs1, funct3, rd, 7'b0110011};
    endfunction

    function automatic logic [31:0] enc_add(
        input logic [4:0] rd,
        input logic [4:0] rs1,
        input logic [4:0] rs2
    );
        return enc_rtype(7'b0000000, rs2, rs1, 3'b000, rd);
    endfunction

    function automatic logic [31:0] enc_addi(
        input logic [4:0] rd,
        input logic [4:0] rs1,
        input int signed imm
    );
        logic [31:0] uimm;
        begin
            uimm = imm;
            return {uimm[11:0], rs1, 3'b000, rd, 7'b0010011};
        end
    endfunction

    function automatic logic [31:0] enc_lui(
        input logic [4:0] rd,
        input int unsigned imm20
    );
        logic [31:0] uimm;
        begin
            uimm = imm20;
            return {uimm[19:0], rd, 7'b0110111};
        end
    endfunction

    function automatic logic [31:0] enc_sw(
        input logic [4:0] rs2,
        input logic [4:0] rs1,
        input int signed imm
    );
        logic [31:0] uimm;
        begin
            uimm = imm;
            return {uimm[11:5], rs2, rs1, 3'b010, uimm[4:0], 7'b0100011};
        end
    endfunction

    function automatic logic [31:0] enc_lw(
        input logic [4:0] rd,
        input logic [4:0] rs1,
        input int signed imm
    );
        logic [31:0] uimm;
        begin
            uimm = imm;
            return {uimm[11:0], rs1, 3'b010, rd, 7'b0000011};
        end
    endfunction

    function automatic logic [31:0] enc_beq(
        input logic [4:0] rs1,
        input logic [4:0] rs2,
        input int signed imm
    );
        logic [31:0] uimm;
        begin
            uimm = imm;
            return {uimm[12], uimm[10:5], rs2, rs1, 3'b000, uimm[4:1], uimm[11], 7'b1100011};
        end
    endfunction

    function automatic logic [31:0] enc_jal(
        input logic [4:0] rd,
        input int signed imm
    );
        logic [31:0] uimm;
        begin
            uimm = imm;
            return {uimm[20], uimm[10:1], uimm[11], uimm[19:12], rd, 7'b1101111};
        end
    endfunction

    task automatic tick(input int cycles);
        begin
            repeat (cycles) begin
                @(posedge clk);
                #1;
            end
        end
    endtask

    task automatic clear_memories();
        begin
            for (int i = 0; i < 256; i++) begin
                dut.instruction_memory1.cache[i] = enc_nop();
                dut.data_memory1.mem[i] = 32'd0;
            end
        end
    endtask

    task automatic load_program();
        begin
            clear_memories();

            // x3 = x1 + x2
            dut.instruction_memory1.cache[0]  = enc_add(5'd3, 5'd1, 5'd2);
            dut.instruction_memory1.cache[1]  = enc_nop();
            dut.instruction_memory1.cache[2]  = enc_nop();
            dut.instruction_memory1.cache[3]  = enc_nop();

            // store x3 to memory[x7 + 0]
            dut.instruction_memory1.cache[4]  = enc_sw(5'd3, 5'd7, 12'd0);

            // load it back to x4
            dut.instruction_memory1.cache[5]  = enc_lw(5'd4, 5'd7, 12'd0);

            // LUI writeback path
            dut.instruction_memory1.cache[6]  = enc_lui(5'd5, 20'h12345);

            // JAL should write pc+4 to x6 and skip cache[8]
            dut.instruction_memory1.cache[7]  = enc_jal(5'd6, 32'd8);
            dut.instruction_memory1.cache[8]  = enc_addi(5'd8, 5'd0, 32'd1);
            dut.instruction_memory1.cache[9]  = enc_addi(5'd9, 5'd0, 32'd2);

            // BEQ should skip cache[11]
            dut.instruction_memory1.cache[10] = enc_beq(5'd1, 5'd1, 32'd8);
            dut.instruction_memory1.cache[11] = enc_addi(5'd10, 5'd0, 32'd3);
            dut.instruction_memory1.cache[12] = enc_addi(5'd11, 5'd0, 32'd4);
        end
    endtask

    task automatic preload_registers();
        begin
            dut.id_stage1.reg_file1.registers[1] = 32'd5;
            dut.id_stage1.reg_file1.registers[2] = 32'd10;
            dut.id_stage1.reg_file1.registers[7] = 32'h0000_0040;
        end
    endtask

    task automatic check_reg(
        input logic [4:0] regno,
        input logic [31:0] expected,
        input string name
    );
        logic [31:0] got;
        begin
            got = dut.id_stage1.reg_file1.registers[regno];
            if (got !== expected) begin
                $fatal(1, "%s FAILED x%0d Expected=0x%08h Got=0x%08h",
                       name, regno, expected, got);
            end
            $display("%s PASSED", name);
        end
    endtask

    task automatic check_mem_word(
        input logic [31:0] addr,
        input logic [31:0] expected,
        input string name
    );
        logic [31:0] got;
        begin
            got = dut.data_memory1.mem[addr[31:2]];
            if (got !== expected) begin
                $fatal(1, "%s FAILED mem[0x%08h] Expected=0x%08h Got=0x%08h",
                       name, addr, expected, got);
            end
            $display("%s PASSED", name);
        end
    endtask

    task automatic wait_for_reg_value(
        input logic [4:0] regno,
        input logic [31:0] expected,
        input int timeout_cycles,
        input string name
    );
        int cycles;
        bit found;
        begin
            cycles = 0;
            found  = 1'b0;
            while (cycles < timeout_cycles && !found) begin
                if (dut.id_stage1.reg_file1.registers[regno] === expected) begin
                    found = 1'b1;
                end
                else begin
                    @(posedge clk);
                    #1;
                    cycles++;
                end
            end

            if (found) begin
                $display("%s PASSED", name);
            end
            else begin
                $fatal(1, "%s FAILED x%0d Expected=0x%08h Got=0x%08h after %0d cycles",
                       name, regno, expected, dut.id_stage1.reg_file1.registers[regno],
                       timeout_cycles);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;

        load_program();

        // Hold reset long enough for the pipeline registers and register file
        // to clear before the test program starts.
        tick(2);

        rst = 1'b0;
        preload_registers();

        $display("\n================================");
        $display("CPU TOP WRAPPER TEST STARTED");
        $display("================================\n");

        // Wait for the architecturally visible writes to land.
        wait_for_reg_value(5'd3,  32'd15,        20, "ADD RESULT");
        wait_for_reg_value(5'd4,  32'd15,        20, "LW RESULT");
        wait_for_reg_value(5'd5,  32'h1234_5000, 20, "LUI RESULT");
        wait_for_reg_value(5'd6,  32'd32,        20, "JAL LINK");
        wait_for_reg_value(5'd8,  32'd0,         20, "JAL FLUSHED INSTR");
        wait_for_reg_value(5'd9,  32'd2,         20, "JAL TARGET");
        wait_for_reg_value(5'd10, 32'd0,         20, "BEQ FLUSHED INSTR");
        wait_for_reg_value(5'd11, 32'd4,         20, "BEQ TARGET");

        check_mem_word(32'h0000_0040, 32'd15, "STORE TO MEMORY");

        $display("\n================================");
        $display("ALL CPU TOP WRAPPER TESTS PASSED");
        $display("================================\n");

        $finish;
    end

endmodule
