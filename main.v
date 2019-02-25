`include "VgaSync.v"

module Counter (
                // Clock
                input i_Clk,

                // VGA control signals
                output o_VGA_HSync,
                output o_VGA_VSync,
                output o_VGA_Red_0,
                output o_VGA_Red_1,
                output o_VGA_Red_2,
                output o_VGA_Grn_0,
                output o_VGA_Grn_1,
                output o_VGA_Grn_2,
                output o_VGA_Blu_0,
                output o_VGA_Blu_1,
                output o_VGA_Blu_2,

	            // Random junk:
	            output o_LED_1,
	            output o_LED_2,
	            output o_LED_3,
	            output o_LED_4
);

   // Turn off the LEDs
   assign o_LED_1 = 0;
   assign o_LED_2 = 0;
   assign o_LED_3 = 0;
   assign o_LED_4 = 0;

   wire                active;
   wire [9:0]           pixel_row;
   wire [9:0]           pixel_col;

   reg [2:0]           red = 0;
   reg [2:0]           green = 0;
   reg [2:0]           blue = 0;

   assign { o_VGA_Red_2, o_VGA_Red_1, o_VGA_Red_0 } = red;
   assign { o_VGA_Grn_2, o_VGA_Grn_1, o_VGA_Grn_0 } = green;
   assign { o_VGA_Blu_2, o_VGA_Blu_1, o_VGA_Blu_0 } = blue;

   // Generate VGA sync signals
   VgaSync sync (
                 .clk(i_Clk),
                 .hsync(o_VGA_HSync),
                 .vsync(o_VGA_VSync),
                 .active(active),
                 .active_row(pixel_row),
                 .active_col(pixel_col)
                 );

   // Video RAM
   wire [3:0]          pixel_color;
         
   RAM_async vram (
              .clk(i_Clk),
              .addr({ pixel_row[6:0], pixel_col[6:0] }),
              .din(4'b1111),
              .dout(pixel_color),
              .we(0)
              );

   // Draw pixels
   always @(posedge i_Clk) begin
      if (active) begin
         if (pixel_row < 128 && pixel_col < 128) begin
            if (pixel_color[3]) red <= 7;
            else red <= 0;
            if (pixel_color[2]) green <= 7;
            else green <= 0;
            if (pixel_color[1]) blue <= 7;
            else blue <= 0;
         end else begin
            red <= 3;
            green <= 3;
            blue <= 5;
         end
      end else begin
         red <= 0;
         green <= 0;
         blue <= 0;
      end
   end
endmodule

/* -----\/----- EXCLUDED -----\/-----
            if (pixel_color == 4'b1111) green <= 7;
            else green <= 0;
            red <= 0;
            blue <= 0;

  if (pixel_color[3]) red <= 7;
 else red <= 0;
 if (pixel_color[2]) green <= 7;
 else green <= 0;
 if (pixel_color[1]) blue <= 7;
 else blue <= 0;
 -----/\----- EXCLUDED -----/\----- */
/* -----\/----- EXCLUDED -----\/-----

module Vram (
             input        clk,
             output [3:0] data_out,
             input [3:0]  data_in,
             input [13:0] address,
             input        write
             );

   reg [3:0]                  memory [0:16383];

   initial begin
      memory[50 + 50 * 128] <= { 1, 1, 1, 1 };
      //memory[0 + 0 * 128] = { 1, 1, 1, 1 };
      //memory[127 + 127 * 128] = { 1, 1, 1, 1 };
      //memory[0 + 127 * 128] = { 1, 1, 1, 1 };
      //memory[127 + 0 * 128] = { 1, 1, 1, 1 };
      memory[0] <= {1, 1, 1, 1};
      //memory[128] = {1, 1, 1, 1};
      memory[256] <= {1, 1, 1, 1};
   end

   always @(posedge clk) begin
      if (write) begin
         memory[address] <= data_in;
      end
      data_out <= memory[address];
   end
endmodule
 -----/\----- EXCLUDED -----/\----- */

module RAM_async(
                 input        clk,
                 input [13:0] addr,
                 input [3:0]  din,
                 output [3:0] dout,
                 input        we
                 );

   reg [3:0]                  mem [0:16383];

   initial begin
`include "mem_init.v"
   end

   always @(posedge clk) begin
      if (we)		// if write enabled
        mem[addr] <= din;	// write memory from din
   end
   assign dout = mem[addr]; // read memory to dout (async)
endmodule
