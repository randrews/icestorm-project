
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
