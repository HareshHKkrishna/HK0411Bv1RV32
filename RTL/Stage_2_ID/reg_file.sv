module reg_file(
    input logic [4:0]rs1,      //read source register 1,
    input logic  [4:0]rs2,     //read source register 2,
    input logic [31:0]wr_data, // write destination register. 
    input logic [4:0]wr_addr,  // write data address.
    input logic wr_en,          // reg_write_enable.
    input logic clk,
    input logic rst,

     

);

endmodule