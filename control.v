module control(clock, resetn, ld, finish, writeEnable, ld_x, ld_y, ld_colour, draw);
	input clock, resetn, ld, finish; //finish = 1 if object reaches end or if object hits obstacle
	output reg writeEnable;
	output reg ld_x;
	output reg ld_y;
	output reg ld_colour;
	output reg draw;
	
	reg [3:0] current_state, next_state; 
	
	localparam   S_BEGIN 				= 4'd0,
					 S_LOAD_VALS      	= 4'd1,
                S_PLOT   				= 4'd2,
                S_PLOT_FINISH   		= 4'd3;
	
	always@(*)
    begin: state_table 
            case (current_state)
					 S_BEGIN: next_state = ld ? S_LOAD_VALS : S_BEGIN;	//Push start key to begin, otherwise do nothing
                S_LOAD_VALS: next_state = ld ? S_LOAD_VALS : S_PLOT; //Let go of start key to plot, otherwise still loading values
                S_PLOT: next_state = finish ? S_PLOT_FINISH : S_PLOT_FINISH; //When object hits end/object collides, go to finishing state
					 S_PLOT_FINISH: next_state = !resetn ? S_BEGIN : S_PLOT_FINISH; //In finish state, object does not move until reset to original position
                
            default:     next_state = S_BEGIN;
        endcase
    end // state_table
	
	always @(*)
    begin: enable_signals
        ld_x = 1'b0;
        ld_y = 1'b0;
        ld_colour = 1'b0;
		  writeEnable = 1'b0;
		  draw = 1'b0;

        case (current_state)
            S_LOAD_VALS: begin
                ld_x = 1'b1;
					 ld_y = 1'b1;
					 ld_colour = 1'b1;
                end
            S_PLOT: begin
					 ld_x = 1'b1;
					 ld_y = 1'b1;
					 ld_colour = 1'b1;
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