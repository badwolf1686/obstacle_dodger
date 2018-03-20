module control(clock, resetn, ld, finish, writeEnable, draw);
	input clock, resetn, ld, finish; //finish = 1 if object reaches end or if object hits obstacle
	output reg writeEnable;
	output reg draw;

	reg [3:0] current_state, next_state; 
	
	localparam  S_BEGIN 				= 4'd0,
				S_LOAD_VALS      		= 4'd1,
				S_PLOT   				= 4'd2,
				S_PLOT_FINISH   		= 4'd3;
	
	always@(*)
	begin: state_table 
			case (current_state)
				//Push start key to begin, otherwise do nothing
				S_BEGIN: next_state = ld ? S_LOAD_VALS : S_BEGIN;
				//Let go of start key to plot, otherwise still loading values	
				S_LOAD_VALS: next_state = ld ? S_LOAD_VALS : S_PLOT; 
				//When object hits end/object collides, go to finishing state
				S_PLOT: next_state = finish ? S_PLOT_FINISH : S_PLOT_FINISH;
				//In finish state, object does not move until reset to original position
				S_PLOT_FINISH: next_state = !resetn ? S_BEGIN : S_PLOT_FINISH; 
			default: next_state = S_BEGIN;
		endcase
	end // state_table
	
	always @(*)
	begin: enable_signals
		writeEnable = 1'b0;
		draw = 1'b0;
		case (current_state)
			S_PLOT: begin
				writeEnable = 1'b1;
				draw = 1'b1;
			end
			S_PLOT_FINISH: begin
				writeEnable = 1'b0;
				draw = 1'b0;
			end
		endcase
	end
	
	always@(posedge clock)
	begin: state_FFs
		if(!resetn)
			current_state <= S_BEGIN;
		else
			current_state <= next_state;
	end // state_FFS
			   
endmodule
