module testbench
	(output logic [3:0] bcd,
	input logic [6:0] segment);
	initial begin
		$monitor($time,,
		"bcd = %b, segment = %b",
	 	bcd, segment);
		bcd = 4'b0000; //0

		#10 bcd = 4'b0001; //1
		#10 bcd = 4'b0010; //2
		#10 bcd = 4'b0011; //3
		#10 bcd = 4'b0100; //4
		#10 bcd = 4'b0101; //5
		#10 bcd = 4'b0110; //6 
		#10 bcd = 4'b0111; //7
		#10 bcd = 4'b1000; //8
		#10 bcd = 4'b1001; //9
		
		//testing invalid  number
		#10 bcd = 4'b1111;
		#10 bcd = 4'b1101;
		#10 bcd = 4'b1010;

		#10 $finish;
	end
endmodule: testbench

module BCDtoSevenSegment
	(input logic [3:0]bcd,
	output logic [6:0] segment);

	always_comb begin
		case(bcd)
			4'b0000: segment = 7'b0000001; //0
			4'b0001: segment = 7'b1001111; //1
			4'b0010: segment = 7'b0010010; //2
			4'b0011: segment = 7'b0000110; //3
			4'b0100: segment = 7'b1001100; //4
			4'b0101: segment = 7'b0100100; //5
			4'b0110: segment = 7'b0100000; //6
			4'b0111: segment = 7'b0001101; //7
			4'b1000: segment = 7'b0000000; //8
			4'b1001: segment = 7'b0000100; //9
			default: segment = 7'b1111111;
		endcase
	end
endmodule: BCDtoSevenSegment

module system;
	logic [3:0] bcd;
	logic [6:0] segment;

	BCDtoSevenSegment testbox (bcd, segment);
	testbench tester (bcd, segment);

endmodule: system
