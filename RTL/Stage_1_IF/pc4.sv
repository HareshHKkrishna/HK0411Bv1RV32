module pc4 (
    input logic [31:0]pc,
    output logic [31:0]pc4
);

always_comb begin
    pc4=pc + 32'd4;
end

endmodule