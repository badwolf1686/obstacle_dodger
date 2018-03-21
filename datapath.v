module datapath(clock, resetn, draw, finish, x, y, colour);
	input clock, resetn, draw;
	output reg finish;
	output [7:0] x;
	output [6:0] y;
	output reg [2:0] colour;
	
	reg [3:0] counter;
	reg [7:0] temp_x, orig_x;
	reg [6:0] temp_y, orig_y;
	
	wire next, frame;
	delay_counter d1(
		.clock(clock),
		.resetn(resetn),
		.enable(draw), // ip
		.go(frame)     // op
		);
		
	frame_counter f1(
		.clock(frame),
		.resetn(resetn),
		.enable(1),
		.next(next)
		);
	
	always @(posedge clock) begin
		if (!resetn) begin
			temp_x <= 8'd10; //obj starts at (10,58)(left top) SETTING
         temp_y <= 7'd58;
			orig_x <= temp_x;
			orig_y <= temp_y;
			colour <= 3'd2; //colour of obs SETTING
			finish <= 1'b0;
      	end
		else if (next && temp_x < 8'd100) begin //erase obj and ready for next drawing
			colour <= 3'd0; 
			temp_x <= orig_x;
			temp_y <= orig_y;
			orig_x <= orig_x + 1'b1;
			finish <= 1'b0;
		end
		else if (temp_x > 8'd100) begin
			finish <= 1'b1;
		end
		else begin
			colour <= 3'd2;
			finish <= 1'b0;
		end
   end
	
	//obj counter
   always @(posedge clock) begin
	   if (!resetn) begin
			counter <= 4'd0; 
	   end
	   else begin
		   counter <= counter + 1;
	   end
   end
	
	assign x = temp_x + counter[1:0];
	assign y = temp_y + counter[3:2];

endmodule


//1/60 delay counter
module delay_counter(clock, resetn, enable, go);
	input clock, resetn, enable;
	output go;
	reg [19:0] delay;
	
	always @(posedge clock)
	begin
		if (!resetn) begin
				delay <= 20'b10111110101111000010000000;//1100_1011_0111_0011_0110; //50,000,000 / 60 - 1(1/60 sec)
			end
		else if (enable) begin
			if (delay == 20'd0) begin
				delay <= 20'b10111110101111000010000000;//b1100_1011_0111_0011_0110;
			end
			else begin
				delay <= delay - 1'b1;
			end
		end
	end
	
	assign go = (delay == 1'b0) ? 1 : 0;
	
endmodule


//frame counter (moving speed)
module frame_counter(clock, resetn, enable, next);
	input clock, resetn, enable;
	output next;
	reg [3:0] frame;
	
	always @(posedge clock)
	begin
		if (!resetn) begin
			frame <= 4'b1110; //60 / 4 - 1(60 / 4 pixels per second) SETTING
		end
		else if (enable) begin
			if (frame == 4'd0) begin
				frame <= 4'b1110;
			end
			else begin
				frame <= frame - 1'b1;
			end
		end
	end
	
	assign next = (frame == 1'b0) ? 1 : 0;
	
endmodule
