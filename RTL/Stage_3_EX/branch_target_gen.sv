import cpu_types_pkg::*;
module branch_target_gen (
    input  logic [31:0] imm,
    input  logic [31:0] pc,
    input  logic [31:0] pc4,
    input  logic        branch_taken,
    input  logic        Jump_ex,
    output logic [31:0] pc_next

);

    always_comb begin
        if (branch_taken||Jump_ex)
            pc_next = pc + imm;
        else
            pc_next = pc4;
    end

endmodule