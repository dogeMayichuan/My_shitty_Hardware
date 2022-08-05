`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/02 23:18:55
// Design Name: 
// Module Name: top
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


module odd_clk_devider 
#(
       parameter CLK_RATION = 5,
       parameter CNT_W= $clog2(CLK_RATION + 1) - 1,
       parameter HIGH_FLIP = CLK_RATION - 1,
       parameter LOW_FLIP = HIGH_FLIP/2
   
)(

     input                          clk,
    input                           arstn,
    output                      clk_out

    );

   //posedge agent
   
   reg [CNT_W:0] P_cnt = 0;
   reg P_clk = 0;
   always@(posedge(clk) or negedge(arstn))begin 
                if(!arstn)begin
                     P_cnt <= 0;
                end
                else if (P_cnt == HIGH_FLIP)begin
                     P_cnt <= 0; 
                end
                else begin
                     P_cnt <= P_cnt + 1;
                end
                
   end
   always@(*)begin
            if(P_cnt == HIGH_FLIP || P_cnt == LOW_FLIP)begin
                    P_clk = ~P_clk;
            end
            else begin
                   P_clk = P_clk;
            end
    end 
    
   //negedge agent
   reg [CNT_W:0] N_cnt = 0;
   reg N_clk = 0;
   always@(negedge(clk) or negedge(arstn))begin 
                if(!arstn)begin
                     N_cnt <= 0;
                end
                else if (N_cnt == HIGH_FLIP)begin
                     N_cnt <= 0; 
                end
                else begin
                     N_cnt <= N_cnt + 1;
                end
                
   end
   always@(*)begin
            if(N_cnt == HIGH_FLIP || N_cnt == LOW_FLIP)begin
                    N_clk = ~N_clk;
            end
            else begin
                   N_clk = N_clk;
            end
    end 
    
    assign clk_out =  N_clk || P_clk;
    
endmodule
