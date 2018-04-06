`default_nettype none

module MagComp
	# (parameter WIDTH = 30)
	(input logic [WIDTH-1:0] A, B,
	 output logic AltB, AeqB, AgtB);

	assign AltB = (A < B);
	assign AeqB = (A == B);
	assign AgtB = (A > B);

endmodule: MagComp

module Adder
	# (parameter WIDTH = 30)
	(input logic [WIDTH-1:0] A, B,
	 input logic Cin,
	 output logic [WIDTH-1:0] S,
	 output logic Cout);

	//always_comb S = A + B + Cin;
	always_comb  {Cout,S} = (A + B + Cin); 

endmodule: Adder

module Multiplexer
	# (parameter WIDTH = 30)
	(input logic [WIDTH-1:0] I,
	 input logic [$clog2(WIDTH)-1:0] S,
	 output logic Y);

	assign Y = I[S];


endmodule: Multiplexer

module Mux2to1
	# (parameter WIDTH = 30)
	(input logic [WIDTH-1:0] I0, I1,
	 input logic s,
	 output logic [WIDTH-1:0] Y);

	assign Y = (s) ? I0 : I1;

endmodule: Mux2to1


module Decoder
	# (parameter WIDTH = 30)
	(input logic  [$clog2(WIDTH)-1:0] I,
	 input logic en,
	 output logic [WIDTH-1:0] D);

	always_comb begin
		D = 0;
		D[I] = en ? 1 : 0;
	end

endmodule: Decoder

module Register
	# (parameter WIDTH = 12)
	(input logic [WIDTH-1:0] D,
	 input logic en, clear, clock,
	 output logic [WIDTH-1:0] Q);


	always_ff @ (posedge clock, posedge clear) begin

		if(clear)
			Q <= 0;
		else
		if(en)
			Q <= D;
			
		end
endmodule: Register

module counter
	# (parameter WIDTH = 30)
	(input logic [WIDTH-1 : 0] D,
	 input logic up, en, clear, load, clock,
	 output logic [WIDTH-1 : 0] Q);

	always_ff @ (posedge clock)
	begin
		if(en)
			if(clear)
				Q <= 0;
			else 
				if(load)
					Q <= D;
				else 
					if(up)
						Q <= Q + 1;
					else
						Q <= (Q>0) ? Q-1 : 0;
	end

endmodule: counter

module shift_register
	# (parameter WIDTH = 30)
	(input logic [WIDTH-1 : 0] D,
	 input logic en, left, load, clock,
	 output logic [WIDTH-1 : 0] Q);

	always_ff @ (posedge clock)
		if(en)
			if(load)
				Q <= D;
			else
				if(left)
					Q = Q<<1;
				else
					Q = Q>>1;


endmodule: shift_register

module Subtracter
	# (parameter WIDTH = 30)
	(input logic [WIDTH-1: 0] F, S,
	 output logic [WIDTH-1: 0] O);

	assign O = F - S;

endmodule: Subtracter







