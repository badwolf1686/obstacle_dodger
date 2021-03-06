//1/60 delay counter
module delay_counter(clock, resetn, enable, go);
	parameter DELAY = 20'b1100_1011_0111_0011_0110; //50,000,000 / 60 - 1(1/60 sec)
	
	input clock, resetn, enable;
	output go;
	reg [19:0] delay;
	
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn) begin
				delay <= DELAY;
			end
		else if (enable) begin
			if (delay == 20'd0) begin
				delay <= DELAY;
			end
			else begin
				delay <= delay - 20'd1;
			end
		end
	end
	
	assign go = (delay == 20'd0) ? 1'b1 : 1'b0;
	
endmodule


//frame counter (moving speed)
module frame_counter(clock, resetn, enable, next);
	parameter FRAME = 4'b1110; //60 / 4 - 1(60 / 4 pixels per second) SETTING
	
	input clock, resetn, enable;
	output next;
	reg [3:0] frame;
	
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn) begin
			frame <= FRAME;
		end
		else if (enable) begin
			if (frame == 4'd0) begin
				frame <= FRAME;
			end
			else begin
				frame <= frame - 4'd1;
			end
		end
	end
	
	assign next = (frame == 4'd0) ? 1'b1 : 1'b0;
	
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
