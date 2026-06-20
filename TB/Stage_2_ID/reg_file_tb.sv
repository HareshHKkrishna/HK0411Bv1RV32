`timescale 1ns/1ns

module reg_file_tb;

    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [31:0] wr_data;
    logic [4:0]  wr_addr;
    logic        wr_en;
    logic        clk;
    logic        rst;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;

    // DUT
    reg_file dut (
        .rs1(rs1),
        .rs2(rs2),
        .wr_data(wr_data),
        .wr_addr(wr_addr),
        .wr_en(wr_en),
        .clk(clk),
        .rst(rst),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial begin

        $display("Starting Register File Test...");

        // Initialize
        rs1     = 0;
        rs2     = 0;
        wr_addr = 0;
        wr_data = 0;
        wr_en   = 0;
        rst     = 1;

        // Apply Reset
        repeat(2) @(posedge clk);
        rst = 0;

        //----------------------------------------------------
        // Test 1 : Verify x0 remains zero
        //----------------------------------------------------
        rs1 = 0;
        #1;
        assert(rs1_data == 32'h0)
        else $error("TEST1 FAILED: x0 is not zero");

        //----------------------------------------------------
        // Test 2 : Write to x5
        //----------------------------------------------------
        @(posedge clk);
        wr_en   <= 1;
        wr_addr <= 5;
        wr_data <= 32'hDEADBEEF;

        @(posedge clk);
        wr_en   <= 0;

        rs1 = 5;
        #1;

        assert(rs1_data == 32'hDEADBEEF)
        else $error("TEST2 FAILED: x5 write/read mismatch");

        //----------------------------------------------------
        // Test 3 : Write to x10
        //----------------------------------------------------
        @(posedge clk);
        wr_en   <= 1;
        wr_addr <= 10;
        wr_data <= 32'h12345678;

        @(posedge clk);
        wr_en   <= 0;

        rs1 = 10;
        #1;

        assert(rs1_data == 32'h12345678)
        else $error("TEST3 FAILED: x10 write/read mismatch");

        //----------------------------------------------------
        // Test 4 : Simultaneous Read
        //----------------------------------------------------
        rs1 = 5;
        rs2 = 10;
        #1;

        assert(rs1_data == 32'hDEADBEEF)
        else $error("TEST4 FAILED: rs1 incorrect");

        assert(rs2_data == 32'h12345678)
        else $error("TEST4 FAILED: rs2 incorrect");

        //----------------------------------------------------
        // Test 5 : Attempt write to x0
        //----------------------------------------------------
        @(posedge clk);
        wr_en   <= 1;
        wr_addr <= 0;
        wr_data <= 32'hFFFFFFFF;

        @(posedge clk);
        wr_en   <= 0;

        rs1 = 0;
        #1;

        assert(rs1_data == 32'h0)
        else $error("TEST5 FAILED: x0 modified");

        //----------------------------------------------------
        // Test 6 : Multiple Writes
        //----------------------------------------------------
        for (int i = 1; i <= 8; i++) begin
            @(posedge clk);
            wr_en   <= 1;
            wr_addr <= i;
            wr_data <= i * 32'h11111111;
        end

        @(posedge clk);
        wr_en <= 0;

        for (int i = 1; i <= 8; i++) begin
            rs1 = i;
            #1;
            assert(rs1_data == i * 32'h11111111)
            else
                $error("TEST6 FAILED: Register %0d mismatch", i);
        end

        $display("====================================");
        $display("ALL TESTS COMPLETED");
        $display("====================================");

        #20;
        $finish;
    end

endmodule