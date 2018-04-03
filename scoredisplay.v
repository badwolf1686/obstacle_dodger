module scoredisplay(score, HEX0, HEX1, HEX2);
	input [7:0] score;
	output [6:0] HEX0, HEX1, HEX2;
	wire [3:0] Hundreds, Tens, Ones;
	
	BCD(.binary(score), .Hundreds(Hundreds), .Tens(Tens), .Ones(Ones));
	decoder dec0(.digits(Ones), .segments(HEX0));
	decoder dec1(.digits(Tens), .segments(HEX1));
	decoder dec2(.digits(Hundreds), .segments(HEX2));
endmodule

module decoder(digit, segments);
    input [3:0] digits;
    output reg [6:0] segments;
   
    always @(*)
        case (digits)
            4'b0000: segments = 7'b100_0000;
            4'b0001: segments = 7'b111_1001;
            4'b0010: segments = 7'b010_0100;
            4'b0011: segments = 7'b011_0000;
            4'b0100: segments = 7'b001_1001;
            4'b0101: segments = 7'b001_0010;
            4'b0110: segments = 7'b000_0010;
            4'b0111: segments = 7'b111_1000;
            4'b1000: segments = 7'b000_0000;
            4'b1001: segments = 7'b001_1000;  
            default: segments = 7'b100_0000;
        endcase
endmodule

//Binary to BCD Conversion using Shift and Add-3 Algorithm 
//Code is from http://www.eng.utah.edu/~nmcdonal/Tutorials/BCDTutorial/BCDConversion.html
module BCD(binary, Hundreds, Tens, Ones);
	input [7:0] binary;
	output reg [3:0] Hundreds;
	output reg [3:0] Tens;
	output reg [3:0] Ones;
	
	integer i;
	always @(binary)
	begin
		Hundreds = 4'd0;
		Tens = 4'd0;
		Ones = 4'd0;
		
		for (i=7; i>=0; i=i-1)
		begin
			//add 3 to columns >= 5
			if (Hundreds >= 5)
				Hundreds = Hundreds + 3;
			if (Tens >= 5)
				Tens = Tens + 3;
			if (Ones >= 5)
				Ones = Ones + 3;
			
			//shift left one
			Hundreds = Hundreds << 1;
			Hundred[0] = Tens[3];
			Tens = Tens << 1;
			Tens[0] = Ones[3];
			Ones = Ones << 1;
			Ones[0] = binary[i];
		end
	end
endmodule
