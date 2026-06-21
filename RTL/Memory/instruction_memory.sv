module instruction_memory (
    input logic [31:0]pc,
    output logic [31:0]instr
);

logic [31:0]cache[255:0];
always_comb begin
    instr=cache[pc[31:2]];          
end
    
endmodule





