module imm_gen(
    input logic [11:0]imm;
    output logic [31:0]imm_data; 
);

assign imm_data = {{20{imm[11]}},imm};

endmodule