module fifo #(parameter DEPTH=1024, DATA_WIDTH=128, UPP_TH=4 , LOW_TH=2 ) (
    input wire clk,                 // Clock signal
    input wire rstn,               // Reset signal
    input wire i_wren,               // Write enable signal
    input wire i_rden,             // Read enable signal
    input wire [127:0] i_wrdata,   // Data input (128 bits)
    output reg [127:0] o_rddata,   // Data output (128 bits)
    output reg o_full,              // Full signal
    output reg o_empty,            // Empty signal
    output reg o_alm_full,          // almost full signal 
    output reg o_alm_empty           // almost empty signal 
);

 // Depth of the FIFO

  reg [127:0] fifo_mem [0:DEPTH-1];   // FIFO memory

  reg [10:0] read_ptr = 0;   // Read pointer
  reg [10:0] write_ptr = 0;  // Write pointer
  reg [10:0] count = 0;      // Count of valid data in the FIFO

  always @(posedge clk ) begin
    if (!rstn) begin
      read_ptr <= 0;
      write_ptr <= 0;
      count <= 0;
      o_full <= 0;
      o_empty <= 1;           // FIFO is empty initially
       o_alm_empty <= 0;
        o_alm_full <=0;
    end 
    else begin
      if (i_wren && (count < DEPTH)) begin
        fifo_mem[write_ptr] <= i_wrdata;
        write_ptr <= write_ptr + 1;
        count++;
      end
      if (i_rden && (count > 0)) begin
        o_rddata <= fifo_mem[read_ptr];
        read_ptr <= read_ptr + 1;
        count--;
       
      end
    end
  
  if(count == DEPTH) begin
        o_full <= 1; // Update full signal
        o_empty <= 0;
       o_alm_empty <= 0;
        o_alm_full <=0;
      end
   
        
      else if (count ==0) begin
         o_empty <= 1;// Update empty signal
        o_full <= 0;
        o_alm_empty <= 0;
        o_alm_full <=0;
   
      end
      
      else if( count >= (DEPTH -UPP_TH-1) && count <DEPTH)
        begin
          o_alm_full <=1;
          o_alm_empty <= 0;
		 o_empty <= 0;// Update empty signal
        o_full <= 0;
        end
      
    else if( count>0 &&  count <= LOW_TH )
        begin
          o_alm_empty <=1;
           o_alm_full <=0;
          o_empty <= 0;// Update empty signal
        o_full <= 0;
        end
      
      else
        begin
           o_full <= 0; // Update full signal
         o_empty <= 0;
          o_alm_full <= 0;
          o_alm_empty <=0;
        end

  end 

endmodule
