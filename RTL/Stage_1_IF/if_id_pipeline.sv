module if_id (
    input  logic        clk,
    input  logic        rst,
    input  logic        stall,
    input  logic        flush,

    input  logic [31:0] instr_in, //instruction from memory i.e the value 
    input  logic [31:0] pc_in,    //instruction address from PC
    input  logic [31:0] pc4_in,   //Instruction address for PC + 4

    output logic [31:0] instr_out,//instruction from memory i.e the value
    output logic [31:0] pc_out,   //instruction address from PC    
    output logic [31:0] pc4_out   //instruction address from PC+4
);

always_ff @(posedge clk) begin

    if (rst || flush) begin
        instr_out <= 32'd0;
        pc_out    <= 32'd0;
        pc4_out   <= 32'd0;
    end

    else if (!stall) begin
        instr_out <= instr_in;
        pc_out    <= pc_in;
        pc4_out   <= pc4_in;
    end

end

endmodule