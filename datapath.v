//160 x 120 screen?

module datapath(clock, resetn, colour, go, x, y, colour_out);
	input clock, resetn;
	input [2:0] colour;
	input go;
	output [7:0] x;
	output [6:0] y;
	output reg [2:0] colour_out;
	
	reg [3:0] counter;
	
	wire next;
	delay_counter d1(
		.clock(clock),
		.resetn(resetn),
		.next()
		);
		
	frame_counter f1(
		.clock(clock),
		.resetn(resetn),
		.out(next)
		);
	
	always @(posedge clock) begin
		if (!resetn) begin
			temp_x <= 8'd10; //obj starts at (10,58)(left top) SETTING
         temp_y <= 7'd58;
			colour_out <= 3'd2; //colour of obs SETTING
      end
      else begin
			if (next) //erase obs and ready for next drawing
				colour_out <= 3'd0; 
		end
   end
	
	//obs counter
   always @(posedge clock) begin
		if (resetn) begin
			counter <= 4'd0; 
      end
		else if (go) begin
			counter <= counter + 1;
		end
   end
	
	assign x = temp_x + counter[1:0];
	assign y = temp_y + counter[3:2];

endmodule


//1/60 delay counter
module delay_counter(clock, resetn, next);
	input clock, resetn;
	output next;
	reg [19:0] delay;
	
	always @(posedge clock)
	begin
		if (resetn | delay == 1'b0)
			begin
				delay <= 20'b1100_1011_0111_0011_0100; //50,000,000 / 60 - 1(1/60 sec)
			end
		else
			delay <= delay - 1'b1;
	end
	
	assign next = (delay == 1'b0) ? 1 : 0;
	
endmodule


//frame counter (moving speed)
module frame_counter(clock, resetn, out);
	input clock, resetn;
	output out;
	reg [3:0] frame;
	
	always @(posedge clock)
	begin
		if (resetn | frame == 1'b0)
			begin
				frame <= 4'b1110; //60 / 4 - 1(60 / 4 pixels per second) SETTING
			end
		else
			frame <= frame - 1'b1;
	end
	
	assign out = (frame == 1'b0) ? 1 : 0;
	
endmodule
