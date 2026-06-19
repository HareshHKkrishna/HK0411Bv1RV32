module instruction_decode (
    input  logic [31:0] ir,

    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,

    output logic [6:0]  opcode,
    output logic [2:0]  func3,
    output logic [6:0]  func7
);

always_comb begin

    opcode = ir[6:0];

    rs1    = 5'd0;
    rs2    = 5'd0;
    rd     = 5'd0;
    func3  = 3'd0;
    func7  = 7'd0;

    case(opcode)

        // R-Type
        7'b0110011 : begin
            rd    = ir[11:7];
            func3 = ir[14:12];
            rs1   = ir[19:15];
            rs2   = ir[24:20];
            func7 = ir[31:25];
        end

        // I-Type ALU
        7'b0010011 : begin
            rd    = ir[11:7];
            func3 = ir[14:12];
            rs1   = ir[19:15];
        end

        // Load
        7'b0000011 : begin
            rd    = ir[11:7];
            func3 = ir[14:12];
            rs1   = ir[19:15];
        end

        // JALR
        7'b1100111 : begin
            rd    = ir[11:7];
            func3 = ir[14:12];
            rs1   = ir[19:15];
        end

        // Store
        7'b0100011 : begin
            func3 = ir[14:12];
            rs1   = ir[19:15];
            rs2   = ir[24:20];
        end

        // Branch
        7'b1100011 : begin
            func3 = ir[14:12];
            rs1   = ir[19:15];
            rs2   = ir[24:20];
        end

        // LUI
        7'b0110111 : begin
            rd = ir[11:7];
        end

        // AUIPC
        7'b0010111 : begin
            rd = ir[11:7];
        end

        // JAL
        7'b1101111 : begin
            rd = ir[11:7];
        end

        default : begin
        end

    endcase

end

endmodule