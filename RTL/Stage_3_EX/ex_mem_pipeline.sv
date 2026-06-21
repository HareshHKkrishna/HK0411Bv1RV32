module ex_mem_pipeline (

    input logic clk,
    input logic rst,


    // Data
    input logic [31:0] alu_result,
    input logic [31:0] rs2_data_mem,
    input logic [4:0]  rd_addr_mem,

    // Control
    input logic       RegWrite_mem,
    input logic       MemRead_mem,
    input logic       MemWrite_mem,
    input wb_select_t WBSelect_mem,

    // Registered Outputs
    output logic [31:0] alu_result_mem_out,
    output logic [31:0] rs2_data_mem_out,
    output logic [4:0]  rd_addr_mem_out,

    output logic       RegWrite_mem_out,
    output logic       MemRead_mem_out,
    output logic       MemWrite_mem_out,
    output wb_select_t WBSelect_mem_out
);

always_ff @(posedge clk) begin

    if (rst) begin

        alu_result_mem_out <= 32'd0;
        rs2_data_mem_out   <= 32'd0;
        rd_addr_mem_out    <= 5'd0;

        RegWrite_mem_out   <= 1'b0;
        MemRead_mem_out    <= 1'b0;
        MemWrite_mem_out   <= 1'b0;

        WBSelect_mem_out   <= WB_ALU;

    end
    else if (!stall) begin

        alu_result_mem_out <= alu_result;
        rs2_data_mem_out   <= rs2_data_mem;
        rd_addr_mem_out    <= rd_addr_mem;

        RegWrite_mem_out   <= RegWrite_mem;
        MemRead_mem_out    <= MemRead_mem;
        MemWrite_mem_out   <= MemWrite_mem;

        WBSelect_mem_out   <= WBSelect_mem;

    end

end

endmodule