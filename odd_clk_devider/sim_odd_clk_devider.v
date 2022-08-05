`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/05 21:35:35
// Design Name: 
// Module Name: sim_odd_clk_devider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim_odd_clk_devider;
reg clk;
reg arstn;
wire clk_out;

odd_clk_devider ins_odd_clk_devider(
.clk(clk),
.arstn(arstn),
.clk_out(clk_out)
);

// clock generation
initial begin
clk = 0;
forever #200 clk = ~clk;
end

// reset generation
initial begin
arstn = 0;
#95 arstn= 1;
end

endmodule
