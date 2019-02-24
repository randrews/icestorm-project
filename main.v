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
   wire [9:0]          pixel_row;
   wire [9:0]          pixel_col;

   wire [2:0]          red = { o_VGA_Red_2, o_VGA_Red_1, o_VGA_Red_0 };
   wire [2:0]          green = { o_VGA_Grn_2, o_VGA_Grn_1, o_VGA_Grn_0 };
   wire [2:0]          blue = { o_VGA_Blu_2, o_VGA_Blu_1, o_VGA_Blu_0 };
   
   // Generate VGA sync signals
   VgaSync sync (
                 .clk(i_Clk),
                 .hsync(o_VGA_HSync),
                 .vsync(o_VGA_VSync),
                 .active(active),
                 .active_row(pixel_row),
                 .active_col(pixel_col)
                 );

   always @(posedge i_Clk) begin
      if (active)
        begin
           if (pixel_col < 200)
             begin
                blue <= 7;
                if (pixel_col > 50 && pixel_col < 150 && pixel_row > 190 && pixel_row < 290)
                  begin
                     red <= 7;
                     green <= 7;
                  end
                else
                  begin
                     red <= 0;
                     green <= 0;
                  end
             end
           else
             begin
                red <= 7;
                if (pixel_row < 240)
                  begin
                     green <= 7;
                     blue <= 7;
                  end
                else
                  begin
                     green <= 0;
                     blue <= 0;
                  end
             end
        end // if (active)
      else
        begin
           red <= 0;
           blue <= 0;
           green <= 0;
        end
   end
endmodule

module VgaSync (
                input            clk,
                output           hsync,
                output           vsync,
                output           active, 
                output reg [9:0] active_row = 0,
                output reg [9:0] active_col = 0
                );

   parameter TOTAL_COLS = 800;
   parameter TOTAL_ROWS = 525;
   parameter ACTIVE_COLS = 640;
   parameter ACTIVE_ROWS = 480;

   reg [9:0]                     row = 0;
   reg [9:0]                     col = 0;

   /* -----\/----- EXCLUDED -----\/-----
    8 pixels front porch
    96 pixels horizontal sync
    40 pixels back porch
    8 pixels left border
    640 pixels video
    8 pixels right border
    ---
    800 pixels total per line
                                  
    2 lines front porch
    2 lines vertical sync
    25 lines back porch
    8 lines top border
    480 lines video
    8 lines bottom border
    ---
    525 lines total per field
    -----/\----- EXCLUDED -----/\----- */

   // Incrementing row and col
   always @(posedge clk) begin
      if (col == TOTAL_COLS - 1)
        begin
           if (row == TOTAL_ROWS - 1)
             begin
                row <= 0;
                col <= 0;
             end
           else
             begin
                col <= 0;
                row <= row + 1;
             end
        end
      else
        col <= col + 1;
   end // always @ (posedge clk)

   // hsync and vsync
   assign hsync = (col >= 96);
   assign vsync = (row >= 2);

   // are we in the active area?
   assign active = (col >= 96+40+8 && col < 96+40+8+640) && (row >= 2+33 && row < 2+33+480);

   // Figure the actual pixel row and column
   always @(posedge clk) begin
      if (active)
        begin
           if (active_col == ACTIVE_COLS-1)
             begin
                if (active_row == ACTIVE_ROWS-1)
                  begin
                     active_row <= 0;
                     active_col <= 0;
                  end
                else
                  begin
                     active_col <= 0;
                     active_row <= active_row + 1;
                  end
             end
           else
             active_col <= active_col + 1;
        end
   end
endmodule
