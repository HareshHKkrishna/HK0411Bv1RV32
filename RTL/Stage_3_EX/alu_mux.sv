module alu_mux(
    input logic ALUSrc,
    input logic [31:0]imm,
    input logic [31:0]rs2_data,
    output logic [31:0]Operand_B
);

assign Operand_B = (ALUSrc) ? imm : rs2_data;
endmodule