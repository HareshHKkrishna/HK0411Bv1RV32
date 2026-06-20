module if_stage (
    input  logic        clk,
    input  logic        rst,
    input  logic        stall,
    input  logic        flush,

    // From branch/jump logic (later)
    input  logic [31:0] pc_next,

    // External Instruction Memory Interface
    output logic [31:0] instr_addr,
    input  logic [31:0] instr_data,

    // Outputs to ID Stage
    output logic [31:0] instr_out,
    output logic [31:0] pc_out,
    output logic [31:0] pc4_out
);

    logic [31:0] pc;
    logic [31:0] pc4;

    //--------------------------------------------------
    // Program Counter
    //--------------------------------------------------
    pc pc_inst (
        .clk     (clk),
        .rst     (rst),
        .stall   (stall),
        .pc_next (pc_next),
        .pc      (pc)
    );

    //--------------------------------------------------
    // PC + 4
    //--------------------------------------------------
    pc4 pc4_inst (
        .pc  (pc),
        .pc4 (pc4)
    );

    //--------------------------------------------------
    // Address to Instruction Memory
    //--------------------------------------------------
    assign instr_addr = pc;

    //--------------------------------------------------
    // IF/ID Pipeline Register
    //--------------------------------------------------
    if_id if_id_inst (
        .clk       (clk),
        .rst       (rst),
        .stall     (stall),
        .flush     (flush),

        .instr_in  (instr_data),
        .pc_in     (pc),
        .pc4_in    (pc4),

        .instr_out (instr_out),
        .pc_out    (pc_out),
        .pc4_out   (pc4_out)
    );

endmodule