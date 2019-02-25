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

   // Color stuff
   reg [2:0]          red = 0;
   reg [2:0]          green = 0;
   reg [2:0]          blue = 0;
   assign { o_VGA_Red_2, o_VGA_Red_1, o_VGA_Red_0 } = red;
   assign { o_VGA_Grn_2, o_VGA_Grn_1, o_VGA_Grn_0 } = green;
   assign { o_VGA_Blu_2, o_VGA_Blu_1, o_VGA_Blu_0 } = blue;

   wire                vga_active;
   wire                active;
   wire [9:0]          vga_row;
   wire [9:0]          vga_col;
   wire [6:0]          pixel_row;
   wire [6:0]          pixel_col;
   wire [3:0]          pixel_color;
   reg                 write = 0;
   reg [13:0]          write_addr;
   wire [13:0]         read_addr = { pixel_row[6:0], pixel_col[6:0] };

   // Generate VGA sync signals
   VgaSync sync (
                 .clk(i_Clk),
                 .hsync(o_VGA_HSync),
                 .vsync(o_VGA_VSync),
                 .active(vga_active),
                 .active_row(vga_row),
                 .active_col(vga_col)
                 );

   // Show a Pico screen inside the VGA screen:
   PicoScreen picoScreen (
                          .clk(i_Clk),
                          .vga_active(vga_active),
                          .vga_row(vga_row),
                          .vga_col(vga_col),
                          .pico_row(pixel_row),
                          .pico_col(pixel_col),
                          .pico_active(active)
                          );

   // Video RAM
   Vram vram (
              .clk(i_Clk),
              .addr(read_addr),
              .write_addr(write_addr),
              .din(4'b1111),
              .dout(pixel_color),
              .we(write)
              );

   // Draw pixels
   always @(posedge i_Clk) begin
      if (active) begin
         if (pixel_color[3]) red <= 7;
         else red <= 0;
         if (pixel_color[2]) green <= 7;
         else green <= 0;
         if (pixel_color[1]) blue <= 7;
         else blue <= 0;
      end else begin
         red <= 0;
         green <= 0;
         blue <= 0;
      end
   end
endmodule

module Vram(
            input            clk,
            input [13:0]     addr,
            input [13:0]     write_addr,
            input [3:0]      din,
            output reg [3:0] dout,
            input            we
            );

   reg [3:0]                 mem [0:16383];

   initial begin
      mem[0] = 'b1111;
      mem[100] = { 'b1010 };
      mem[356] = { 'b1010 };
      mem[127] = { 'b1010 };
      mem[0 + 127 * 128] = 'b1000;
      mem[127 + 127 * 128] = 'b0100;
   end

   always @(posedge clk) begin
      if (we) mem[write_addr] <= din;
      dout <= mem[addr];
   end
endmodule

module PicoScreen (
                   input            clk,
                   input            vga_active,
                   input [9:0]      vga_row,
                   input [9:0]      vga_col,
                   output reg       pico_active,
                   output reg [6:0] pico_row = 0,
                   output reg [6:0] pico_col = 0
                   );

   // We're active for a 384x384-vga-pixel block in the center of the screen
   reg [3:0]                        coldiv3;
   reg [3:0]                        rowdiv3;

   always @(posedge clk) begin
      if (vga_row >= 48 && vga_row < 432 && vga_col >= 128 && vga_col < 512) begin
         pico_active <= 1;
         if (coldiv3 == 2) begin
            coldiv3 <= 0;
            if (pico_col == 127) begin
               pico_col <= 0;
               if (rowdiv3 == 2) begin
                  rowdiv3 <= 0;
                  pico_row <= pico_row + 1;
               end else begin
                  rowdiv3 <= rowdiv3 + 1;
               end
            end else begin
               pico_col <= pico_col + 1;
            end
         end else begin
            coldiv3 <= coldiv3 + 1;
         end
      end else begin
         //ckdiv3 <= 0;
         pico_active <= 0;
      end
   end
endmodule
