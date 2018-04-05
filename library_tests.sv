`default_nettype none


module testBench();

logic [7:0] A, B, S; logic clr;

logic AltB, AeqB, AgtB;
MagComp #(8) myComp(A, B, AltB, AeqB, AgtB);

logic Cin, Cout;
Adder #(8) myAdd(A, B, Cin, S, Cout);

logic [7:0] I; logic [2:0] SM; logic Y;
Multiplexer #(8) myMux(I, SM, Y);

logic [7:0] I0, I1, YM; logic s;
Mux2to1 #(8) myMux2(I0, I1, s, YM);

logic [2:0] DI; logic en; logic[7:0] D; 
Decoder #(8) myDec(DI, en, D);

logic clock;
logic [7:0] DR, QR;
Register #(8) myReg(DR, en, clr, clock, QR);

logic [7:0] DC; logic up, load; logic [2:0] QC;
counter #(8) myCount(DC, up, en, clr, load, clock, QC);

// logic [7:0] DS, QS;
// shift_register #(8) myShift	(DS, en, 1, 0, clock, QS);


initial begin
	clock = 0;
	
    forever #5 clock = ~clock;
end

initial begin
	clr = 1;
	clr <= 0;
	// //MagComp
	// #1 A = 8'b10001000; B = 8'b00001111;
	// $display("MacComp %d A %b B %b AltB %b AeqB %b AgtB %b",$time,A ,B, AltB, AeqB, AgtB);

	// //Adder
	// Cin = 0;
	// #1 
	// $display("Adder %d A %b B %b Cin %b S %b Cout %b",$time,A ,B, Cin, S, Cout);

	// //Multiplexer
	// I = 8'b10001000; SM = 3'B011;
	// #1 
	// $display("Multiplexer %d I %b SM %b Y %b",$time,I ,SM, Y);

	// //Mux2to1
	// I0 = 8'b10001000; I1 = 8'b00001111; s = 1;
	// #1 
	// $display("Mux2to1 %d I0 %b I1 %b s %b YM %b",$time, I0,I1,s,YM);

	// //Decoder
	// DI = 3'b111; en = 1;
	// #1 
	// $display("Decoder %d I %b en %b D %b",$time, DI, en, D);

	// //Register
	// DR = 8'b10001000; en = 1;
	// #1 
	// $display("Register %d DR %b en %b clear %b clock %b Q %b",$time, DR, en, clr, clock, QR);

	//Counter

	$monitor("counter DC: %b up: %b en: %b clear: %b load: %b clock: %b QC: %b", DC, up, en, clr, load, clock, QC);
	en = 0;
	DC = 8'b0;
	@(posedge clock);
	@(posedge clock);

	DC = 8'b001; en = 1; up = 1; load = 1;

	

	@(posedge clock);
	load = 0;

	@(posedge clock);
	@(posedge clock);
	@(posedge clock);
	@(posedge clock);
	  


	
 
	// //Shift-Register
	// DR = 8'b10001000; en = 1; 
	// #1 
	// $display("Shift_register DS %b en %b clock %b QS %b", $time, DS, en, clock, QS);

	$finish;


end

endmodule: testBench