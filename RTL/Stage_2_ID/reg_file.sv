`timescale 1ns/1ns
import cpu_types_pkg::*;
module reg_file(
    input logic [4:0]rs1,      //read source register 1,
    input logic  [4:0]rs2,     //read source register 2,
    input logic [31:0]wr_data, // write destination register. 
    input logic [4:0]wr_addr,  // write data address.
    input logic wr_en,          // reg_write_enable.
    input logic clk,
    input logic rst,
    output logic [31:0]rs1_data,// Register 1 data.
    output logic [31:0]rs2_data // Register 2 data.
);  
    logic [31:0]registers[31:0];
    always_ff @( posedge clk ) begin
        if(rst)begin
            for(int i=0;i<32;i++)begin
                registers[i]<=32'b0;
            end
        end
        else if(wr_en && wr_addr!=0)begin
            registers[wr_addr]<=wr_data;
        end    
    end

    always_comb begin
        if(rs1== 0)
            rs1_data=0;
        else
            rs1_data=registers[rs1];
        if(rs2==0)
            rs2_data=0;
        else
            rs2_data=registers[rs2];
    end
endmodule
