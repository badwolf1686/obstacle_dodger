module obs_datapath(clock, resetn, draw, x, y, colour);
	input clock, resetn, draw;
//	output reg finish;
	output [7:0] x;
	output [6:0] y;
	output reg [2:0] colour;

	reg down;
	reg [4:0] counter;
	reg [7:0] temp_x, orig_x;
	reg [6:0] temp_y, orig_y;

	wire [4:0] random_num;
	//random number from 64 to 95 (x position)
	fibonacci_lfsr_5bit r1(
		.clk(clock),
		.rst_n(resetn),

		.data(random_num)
		);

	initial begin
		temp_x <= 8'd60;
      temp_y <= 7'd0;
		orig_x <= 8'd60;
		orig_y <= 7'd0;
		colour <= 3'd0; //initially does not show the obstacle
//		finish <= 1'b0;
		down <= 1'b1;
		counter <= 5'b11111;
	end

  wire next, frame;
	delay_counter d1(
		.clock(clock),
		.resetn(resetn),
		.enable(draw), // ip

		.go(frame) // op
		);

	frame_counter f1(
		.clock(frame),
		.resetn(resetn),
		.enable(1),

		.next(next)
		);

	always @(posedge next) begin
		if (!resetn) begin
			temp_x <= {3'b010, random_num}; //obj starts at (rand,0)(left top) SETTING
			temp_y <= 7'd0;
			orig_x <= temp_x;
			orig_y <= temp_y;
			colour <= 3'd1; //colour of obs SETTING
//			finish <= 1'b0;
			down <= 1'b1;
      	end
		else if (next) begin //erase obj and ready for next drawing
			colour <= (colour == 3'd0) ? 3'd1 : 3'd0;
			temp_x <= orig_x;
			temp_y <= orig_y;
//			finish <= 1'b1;

			if (down) begin
				orig_y <= orig_y + 7'd1;
			end
			else begin
				orig_y <= orig_y - 7'd1;
			end
		end
		
		//change direction (up or down) when reaches the boundary
		if (temp_y >= 7'd104) begin
			down <= 1'b0;
		end
		if (temp_y <= 7'd0) begin
			down <= 1'b1;
		end
   end

	//obs counter
   always @(posedge clock) begin
	   if (!resetn) begin
			counter <= 5'd0;
	   end
	   else if (draw) begin
		   counter <= counter + 5'd1;
	   end
   end

	assign x = temp_x + counter[4];
	assign y = temp_y + counter[3:0];

endmodule
