module SevenSeg (
	input[3:0] number,
	output[0:6] segments
);

assign segments[0] = (number == 1 || number == 4 || number == 7);
assign segments[1] = (number == 5 || number == 6);
assign segments[2] = (number == 2);
assign segments[3] = (number == 1 || number == 4 || number == 7);
assign segments[4] = (number == 1 || number == 3 || number == 4 || number == 5 || number == 7 || number == 9);
assign segments[5] = (number == 1 || number == 2 || number == 3 || number == 7);
assign segments[6] = (number == 0 || number == 1 || number == 7);

endmodule
