`timescale 1ns / 1ps



module Asychrouns_fifo
#(
parameter fifo_depth  = 32 ,    //FIFO DEPTH
parameter fifo_width  = 8,      // this bitch must greater than 2 and is a number of the power of 2.
parameter add_width = $clog2(fifo_depth) //5
)
(
//global reset
input                                                                               rst_n,
// Write interface
input                                                                             w_clk,
input   [fifo_width - 1 : 0]                                     w_data,
input                                                                             w_en,
output                                                                          w_almost_full,

//read interface 
input                                                                                r_clk,
output             [fifo_width - 1 : 0]                          r_data,
input                                                                                r_en,
output                                                                             r_almost_empty,
 output           [add_width : 0]                                                         d1_w   ,d2_r,
 output           [fifo_width - 1:0]                       f1,f2,f3,f4,f5
    );
    
    //read and writer pointers
    reg [add_width : 0] w_ptr = 0;  
    reg [add_width: 0 ] r_ptr  = 0;


    // address line
   // wire [add_width - 1: 0]  w_add   ;
   // wire [add_width - 1: 0]   r_add   ;
    
   // assign w_add = w_ptr  [add_width - 1:0]   ;
   // assign r_add  = r_ptr[add_width -1 :0]  ;
    
    //graycode encoder
    wire [add_width: 0] w_ptr_gray ;
    wire [add_width:0]  r_ptr_gray ;
    
    assign w_ptr_gray = (w_ptr >> 1 ) ^ w_ptr;
    assign r_ptr_gray   = (r_ptr  >> 1)  ^ r_ptr;
    
       assign  d1_w = w_ptr_gray;


    //sychronzation chain
     //r2w   
     
    reg [add_width : 0] r2w_1,r2w_2 = 0;
    
       assign  d2_r = r2w_2;
       
       
  always@(posedge w_clk or negedge rst_n)begin
                      if(~rst_n)begin
                                        {r2w_2, r2w_1} <= 0;
                       end
                       else begin
                                        {r2w_2,r2w_1} <= {r2w_1,r_ptr_gray};
                       end      
  end
  
  
  //w2r
  
      reg [add_width : 0] w2r_1,w2r_2 = 0;
      
always @(posedge r_clk or negedge rst_n)begin
                       if (!rst_n )begin
                                    {w2r_2,w2r_1} <= 0;
                          end
                         else begin
                                    {w2r_2,w2r_1} <= {w2r_1,w_ptr_gray} ;
                         end
end
    
    //write pointer 
    
    always @(posedge w_clk or negedge rst_n)begin
                    if(!rst_n)begin
                                    w_ptr <= 0;
                    end
                    else if (w_en && ! w_almost_full)begin
                                    w_ptr <= w_ptr + 5'b00001;
                    end

    end
    
    // read pointer 
    
      always @(posedge r_clk or negedge rst_n)begin
                    if(!rst_n)begin
                                    r_ptr <= 0;
                    end
                    else if (r_en &&! r_almost_empty)begin
                                    r_ptr <= r_ptr +5'b00001;
                    end

    end
    
    // empty and full signal generation
    
    assign r_almost_empty = (w2r_2 == r_ptr_gray)?   1'b1:1'b0;
   assign w_almost_full = ((r2w_2[add_width] != w_ptr_gray[add_width]) &
                                                        (r2w_2[add_width-1] != w_ptr_gray[add_width-1])&
                                                       (r2w_2[add_width - 2 :0] == w_ptr_gray[add_width -2:0 ]))?                                 1'b1:1'b0;    
    
    // RAM instance    
    
   reg [fifo_width - 1: 0 ] RAM [0:fifo_depth - 1] ;
   
   
   initial begin
   $readmemb("test.mem",RAM);
   
end



   //write
   always@(posedge w_clk)begin
                if (w_en && ! w_almost_full)begin
                            RAM[w_ptr[add_width - 1: 0]] <= w_data;
                end

   end
   // read
assign r_data = RAM[r_ptr[add_width - 1: 0]];
   
   assign f1 = RAM[0];
      assign f2 = RAM[1];
         assign f3 = RAM[2];
            assign f4 = RAM[3];
               assign f5 = RAM[4];
   
   endmodule
