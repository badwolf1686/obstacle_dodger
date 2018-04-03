module scoredisplay(score, HEX0, HEX1, HEX2);
	input [8:0] score;
	output [6:0] HEX0, HEX1, HEX2;
	
	binary_decoder b0(.score(score), .segments0(HEX0), .segments1(HEX1), .segments2(HEX2));
endmodule

//still working on this, need to convert score (binary) to 3 hex segments
module binary_decoder(score, segments0, segments1, segments2);
    input [8:0] score;
    output reg [6:0] segments0, segments1, segments2;
   
    always @(*)
        case (score)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;  
            default: segments = 7'b100_0000;
        endcase
endmodule
