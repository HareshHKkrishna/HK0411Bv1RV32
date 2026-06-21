module data_memory (
    input  logic        clk,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    input  logic        we,
    output logic [31:0] rdata
);

logic [31:0] mem [255:0];

always_comb begin
    rdata = mem[addr[31:2]];
end

always_ff @(posedge clk) begin
    if (we)
        mem[addr[31:2]] <= wdata;
end

endmodule