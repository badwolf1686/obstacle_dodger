module datapath(clock, resetn, draw, setoff, finish, x, y, colour);
	input clock, resetn, draw, setoff;
	output reg finish;
	output reg [7:0] x;
	output reg [6:0] y;
	output reg [2:0] colour;
	
	reg [3:0] counter;
	reg is_obs;
	reg [7:0] temp_x, orig_x;
	reg [6:0] temp_y, orig_y;
	
	wire [7:0] obs_x;
	wire [6:0] obs_y;
	wire [2:0] obs_colour;
	wire obs_finish;
	
   	wire next, frame;
	delay_counter d1(
		.clock(clock),
		.resetn(resetn),
		.enable(setoff & (counter == 4'b1111)), // ip
		
		.go(frame)     // op
		);
		
	frame_counter f1(
		.clock(frame),
		.resetn(resetn),
		.enable(1),
		
		.next(next)
		);
	
	//obstacle datapath
	obs_datapath od1(
		.clock(clock),
		.resetn(resetn),
		.draw(draw),
		
		.finish(obs_finish),
		.x(obs_x),
		.y(obs_y),
		.colour(obs_colour),
		);
	
	always @(posedge clock) begin
		if (!resetn) begin
			temp_x <= 8'd10; //obj starts at (10,58)(left top) SETTING
         temp_y <= 7'd58;
			orig_x <= temp_x;
			orig_y <= temp_y;
//			colour <= 3'd2; //colour of obs SETTING
			finish <= 1'b0;
      	end
		else if (next) begin //erase obj and ready for next drawing
//			colour <= 3'd0; 
			temp_x <= orig_x;
			temp_y <= orig_y;
			finish <= 1'b0;
		end
		else if (temp_x > 8'd100) begin
//			colour <= 3'd2;
			finish <= 1'b1;
		end
		else begin
//			colour <= 3'd2;
			finish <= 1'b0;
		end
	end
	
	//draw counter
   always @(posedge clock) begin
	   if (!resetn) begin
			counter <= 4'd0;
		   	is_obs <= 1'b1;
	   end
	   else if (draw) begin
		   counter <= counter + 1;
	   end
	   
	   if (counter == 4'b1111) begin
		   is_obs <= !is_obs;
	   end
   end
	
	always @(*) begin
		if (is_obs) begin
			x <= obs_x;
			y <= obs_y;
			end
		else begin
			x <= temp_x + counter[1:0];
			y <= temp_y + counter[3:2];
		end
	
		if (next) begin
			colour <= 3'd0;
		end
		else begin
			colour <= is_obs ? obs_colour : 3'd2;
		end
	end

endmodule
