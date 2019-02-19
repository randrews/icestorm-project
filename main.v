`include "SevenSeg.v"

module Counter (
	input i_Switch_1,
	input i_Switch_2,

	output o_Segment1_A,
	output o_Segment1_B,
	output o_Segment1_C,
	output o_Segment1_D,
	output o_Segment1_E,
	output o_Segment1_F,
	output o_Segment1_G,

	// Random junk:
	output o_LED_1,
	output o_LED_2,
	output o_LED_3,
	output o_LED_4
);

assign o_LED_1 = 0;
assign o_LED_2 = 0;
assign o_LED_3 = 0;
assign o_LED_4 = 0;

reg [3:0] num = 4'd0;

SevenSeg digit(
	.number(num),
	.segments({
		o_Segment1_A,
		o_Segment1_B,
		o_Segment1_C,
		o_Segment1_D,
		o_Segment1_E,
		o_Segment1_F,
		o_Segment1_G })
);

always @(posedge i_Switch_1) begin
	if (num < 9) num <= num + 4'd1;
	else num <= 4'd0;
end

endmodule
