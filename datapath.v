module datapath(clock, resetn, draw, setoff, finish, x, y, colour);
	input clock, resetn, draw, setoff;
	output reg finish;
	output reg [7:0] x;
	output reg [6:0] y;
	output reg [2:0] colour;

	reg [3:0] counter;
//	reg is_obs;
	reg [7:0] temp_x, orig_x;
	reg [6:0] temp_y, orig_y;
	
	reg [1:0] which;

	wire [7:0] obs_x0;
	wire [6:0] obs_y0;
	wire [7:0] obs_x1;
	wire [6:0] obs_y1;
	wire [7:0] obs_x2;
	wire [6:0] obs_y2;
	wire [2:0] obs_colour0;
	wire [2:0] obs_colour1;
	wire [2:0] obs_colour2;
//	wire [2:0] obs_finish;

	initial begin
		temp_x <= 8'd10; //obj starts at (10,58)(left top) SETTING
		temp_y <= 7'd58;
		orig_x <= 8'd10;
		orig_y <= 7'd58;
		finish <= 1'b0;
		counter <= 4'b1111;
		colour <= 3'd2;
//		is_obs <= 1'd0;
		which <= 2'd0;
	end

   wire next, frame;
	delay_counter d1(
		.clock(clock),
		.resetn(resetn),
		.enable(setoff), // ip

		.go(frame)     // op
		);

	frame_counter f1(
		.clock(frame),
		.resetn(resetn),
		.enable(frame),

		.next(next)
		);

	//obstacle datapath
	obs_datapath od0(
		.clock(clock),
		.resetn(resetn),
		.draw(draw),

//		.finish(obs_finish[0]),
		.x(obs_x0),
		.y(obs_y0),
		.colour(obs_colour0)
		);

	obs_datapath od1(
		.clock(clock),
		.resetn(resetn),
		.draw(draw),

//		.finish(obs_finish[1]),
		.x(obs_x1),
		.y(obs_y1),
		.colour(obs_colour1)
		);

	obs_datapath od2(
		.clock(clock),
		.resetn(resetn),
		.draw(draw),

//		.finish(obs_finish[2]),
		.x(obs_x2),
		.y(obs_y2),
		.colour(obs_colour2)
		);

	always @(posedge next) begin
		if (!resetn) begin
			temp_x <= 8'd10; //obj starts at (10,58)(left top) SETTING
         temp_y <= 7'd58;
			orig_x <= 8'd10;
			orig_y <= 7'd58;
			finish <= 1'b0;
			colour <= 3'd2;
      	end
		else if (next) begin //start erase obj and ready for next drawing
			temp_x <= orig_x;
			temp_y <= orig_y;
			finish <= 1'b0;
			orig_x <= orig_x + 8'd1;
			colour <= (colour == 3'd0) ? ((which == 2'd1) ? obs_colour0 : 3'd2) : 3'd0;
		end
		else if (temp_x > 8'd130) begin
			finish <= 1'b1;
		end
		else begin
			finish <= 1'b0;
		end
		
		if (colour == 3'd0) begin
			which <= which + 2'd1;
		end
	end

	//draw counter
   always @(posedge clock) begin
	   if (!resetn) begin
			counter <= 4'd0;
//			is_obs <= 1'd0;
	   end
	   else if (draw) begin
		   counter <= counter + 4'd1;
	   end

//	   if (colour == 3'd0) begin
//		   is_obs <= !is_obs;
//	   end
   end

	always @(posedge clock) begin
		case (which)
			2'd0: begin
				x <= temp_x + counter[1:0];
				y <= temp_y + counter[3:2];
			end
			2'd1: begin
				x <= obs_x0;
				y <= obs_y0;
			end
			2'd2: begin
				x <= obs_x1;
				y <= obs_y1;
			end
			2'd2: begin
				x <= obs_x2;
				y <= obs_y2;
			end
		endcase
	end

endmodule
