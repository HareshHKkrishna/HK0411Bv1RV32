typedef enum logic [2:0]{
    ALUOP_LW_SW,
    ALUOP_BRANCH,
    ALUOP_RTYPE,
    ALUOP_ITYPE,
    ALUOP_UPPERIMM,
    ALUOP_JUMP
} aluop_t;
module alu_control (
    input aluop_t ALUOp,
    input logic [2:0]func3,
    input logic [6:0]func7,
    output logic [3:0]alu_control
);
   always_comb begin
    alu_control = 4'b1111;

    if(ALUOp == ALUOP_RTYPE) begin
        case ({func7,func3})

            {7'b0000000,3'b000}: alu_control = 4'b0000; // ADD
            {7'b0100000,3'b000}: alu_control = 4'b0001; // SUB
            {7'b0000000,3'b001}: alu_control = 4'b0010; // SLL
            {7'b0000000,3'b010}: alu_control = 4'b0011; // SLT
            {7'b0000000,3'b011}: alu_control = 4'b0100; // SLTU
            {7'b0000000,3'b100}: alu_control = 4'b0101; // XOR
            {7'b0000000,3'b101}: alu_control = 4'b0110; // SRL
            {7'b0100000,3'b101}: alu_control = 4'b0111; // SRA
            {7'b0000000,3'b110}: alu_control = 4'b1000; // OR
            {7'b0000000,3'b111}: alu_control = 4'b1001; // AND

            default: alu_control = 4'b1111;
        endcase
    end

    else if(ALUOp == ALUOP_ITYPE) begin
        case (func3)

            3'b000: alu_control = 4'b0000; // ADDi
            3'b010: alu_control = 4'b0011; // SLTi
            3'b011: alu_control = 4'b0100; // SLTUi
            3'b100: alu_control = 4'b0101; // XORi
            3'b110: alu_control = 4'b1000; // ORi
            3'b111: alu_control = 4'b1001; // ANDi
            

            default: alu_control = 4'b1111;
        endcase
            if(func3 == 001 && func7==0000000)begin
                alu_control = 4'b0010;
            end
            else if(func3 == 101 && func7==0000000)begin
                alu_control = 4'b0110;
            end
            else if(func3 == 101 && func7==0100000)begin
                alu_control = 4'b0111;
            end
    end
    else if(ALUOp == ALUOP_BRANCH) begin
        case (func3)

            3'b000: alu_control = 4'b0001; // BEQ
            3'b001: alu_control = 4'b0001; // BNE
    
        default: alu_control = 4'b1111;
        endcase
    end
    else if(ALUOp == ALUOP_JUMP) begin
        alu_control=4'b0000;
    end
    else if(ALUOp == ALUOP_UPPERIMM) begin
        alu_control=4'b1010;
    end
    else if(ALUOp == ALUOP_LW_SW) begin
        case (func3)

            3'b000: alu_control = 4'b0000; // LW
            3'b010: alu_control = 4'b0000; // SW
            

            default: alu_control = 4'b1111;
        endcase
    end


   end    
endmodule