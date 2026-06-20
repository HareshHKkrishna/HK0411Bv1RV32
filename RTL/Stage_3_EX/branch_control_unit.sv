module branch_control_unit (
    input logic [31:0]rs1_data,
    input logic [31:0]rs2_data,
    input logic [2:0]func3,
    input logic branch,
    output logic branch_taken
);

always_comb begin
    branch_taken = 1'b0;
    if(branch) begin
        if(func3==3'b000)begin
            branch_taken=(rs1_data==rs2_data);
        end
        else if(func3==3'b001)begin
            branch_taken=(rs1_data!=rs2_data);
        end
end
end
    
endmodule