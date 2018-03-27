module obs_datapath(clock, resetn, draw, finish, x, y, colour);
	input clock, resetn, draw;
	output reg finish;
	output [7:0] x;
	output [6:0] y;
	output reg [2:0] colour;
	
	reg down;
	reg [4:0] counter;
	reg [7:0] temp_x, orig_x;
	reg [6:0] temp_y, orig_y;
	
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
	
	wire [4:0] random_num;
	//random number from 64 to 95 (x position)
	module fibonacci_lfsr_5bit r1(
		.clk(clock),
		.rst_n(resetn),
		.data(random_num)
		);
	
	always @(posedge clock) begin
		if (!resetn) begin
			temp_x <= {3'b010, random_num}; //obj starts at (rand,0)(left top) SETTING
         	temp_y <= 7'd0;
			orig_x <= temp_x;
			orig_y <= temp_y;
			colour <= 3'd1; //colour of obs SETTING
			finish <= 1'b0;
			down <= 1'b1;
      	end
		else if (next) begin //erase obj and ready for next drawing
			colour <= 3'd0;
			temp_x <= orig_x;
			temp_y <= orig_y;
			finish <= 1'b0;
		end
		else begin
			colour <= 3'd1;
			finish <= 1'b0;
		end
		
		//change direction (up or down) when reaches the boundary
		if (temp_y >= 7'd104) begin
			down <= 1'b0;
		end
		if (temp_y <= 7'd0) begin
			down <= 1'b1;
		end
   end
	
	//increment orig_y when start erasing obj
	always @(posedge next) begin
		if (down) begin
			orig_y <= orig_y + 1;
		end
		else begin
			orig_y <= orig_y - 1;
		end
	end
	
	//obj counter
   always @(posedge clock) begin
	   if (!resetn) begin
			counter <= 5'd0;
	   end
	   else if (draw) begin
		   counter <= counter + 1;
	   end
   end
	
	assign x = temp_x + counter[4];
	assign y = temp_y + counter[3:0];

endmodule


//1/60 delay counter
module delay_counter(clock, resetn, enable, go);
	input clock, resetn, enable;
	output go;
	reg [19:0] delay;
	
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn) begin
				delay <= 20'b1100_1011_0111_0011_0110; //50,000,000 / 60 - 1(1/60 sec)
			end
		else if (enable) begin
			if (delay == 20'd0) begin
				delay <= 20'b1100_1011_0111_0011_0110;
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
	
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn) begin
			frame <= 4'b1010; //(10 pixels per second) SETTING
		end
		else if (enable) begin
			if (frame == 4'd0) begin
				frame <= 4'b1010;
			end
			else begin
				frame <= frame - 1'b1;
			end
		end
	end
	
	assign next = (frame == 1'b0) ? 1 : 0;
	
endmodule


//fibonacci random generator
//https://stackoverflow.com/a/20145147
module fibonacci_lfsr_5bit(
  	input clk,
  	input rst_n,

	output reg [4:0] data
);

	reg [4:0] data_next;

	always @(*) begin
  		data_next[4] = data[4]^data[1];
  		data_next[3] = data[3]^data[0];
  		data_next[2] = data[2]^data_next[4];
  		data_next[1] = data[1]^data_next[3];
  		data_next[0] = data[0]^data_next[2];
	end

	always @(posedge clk or negedge rst_n)
  		if(!rst_n)
    		data <= 5'h1f;
  		else
    		data <= data_next;

endmodule
