`default_nettype none

module testBench();

  //testSplit split ();

  testLoadMasterPattern();

endmodule: testBench

module testLoadMasterPattern();


    logic [2:0] LoadShape; 
    logic [1:0] ShapeLocation;
    logic loadingShape, startGame, clock;
    logic [11:0] masterPattern; logic masterLoaded;


    loadMasterPattern loadMaster(LoadShape, ShapeLocation, loadingShape, startGame, clock, masterPattern, masterLoaded);

    initial begin
    	clock = 0;
    	forever #5 clock = ~clock;
    end

    initial begin

    	$monitor("Loadshape %b into %b location -> masterPattern: %b ", LoadShape, ShapeLocation, masterPattern);
    	
		@(posedge clock);
		@(posedge clock);
    	LoadShape = 3'b001;
    	ShapeLocation = 2'b00;
    	@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);

		$finish;


    end


endmodule: testLoadMasterPattern

module testChecks;

  logic [11:0] masterPattern, Guess;
  logic [3:0] Znarly;

  testCheckForZnarly znarlyTester (.*);
  checkForZnarly znarlyBox (.*);

endmodule: testChecks;

module testCheckForZnarly
  (output logic [11:0] masterPattern, Guess,
  input logic [3:0] Znarly);
  
  initial begin
	$monitor("Master: %b, Guess: %b, Znarly: %b", masterPattern, Guess, Znarly);

	masterPattern = 12'b000000000000;
	Guess = 12'b000000000000;

	#5 masterPattern = 12'b001010011100; Guess = 12'b001010011100; 

	$display("testing 3 znarlys");
	//test 3 Znarly
	#5 masterPattern = 12'b001010011100; Guess = 12'b011010011100;
	#5 masterPattern = 12'b001010011100; Guess = 12'b001110011100;
	#5 masterPattern = 12'b001010011100; Guess = 12'b001010001100;
	#5 masterPattern = 12'b001010011100; Guess = 12'b001010011101;

	$display("testing 2 znarlys");
	//test 2 Znarly
	#5 masterPattern = 12'b001010011100; Guess = 12'b011011011100;
	#5 masterPattern = 12'b001010011100; Guess = 12'b101110011100;
	#5 masterPattern = 12'b001010011100; Guess = 12'b001010001101;
	#5 masterPattern = 12'b001010011100; Guess = 12'b100010011101;

	$display("testing 1 znarlys");
	//test 1 Znarly
	#5 masterPattern = 12'b001010011100; Guess = 12'b011011100100;
	#5 masterPattern = 12'b001010011100; Guess = 12'b101100011101;
	#5 masterPattern = 12'b001010011100; Guess = 12'b011010100101;
	#5 masterPattern = 12'b001010011100; Guess = 12'b001110001001;

	$display("testing 0 znarlys");
	//test 0 Znarly
	#5 masterPattern = 12'b001010011100; Guess = 12'b011011100101;
	#5 masterPattern = 12'b001010011100; Guess = 12'b101101011101;
	#5 masterPattern = 12'b001010011100; Guess = 12'b011001100101;
	#5 masterPattern = 12'b001010011100; Guess = 12'b101110001001;

	$finish;
  end

endmodule: testCheckForZnarly


// module testSplit();


//   logic [11:0] test; logic [2:0] o3, o2, o1, o0;
//   sliceInput slice(test, o3, o2, o1, o0);

//   initial begin
//     $display("slicing...");

    

//     $monitor("slice %b into %b %b %b %b", test, o3, o2, o1, o0);

//     #5 test <= 12'b111111111111;

//     #5 test <= 12'b111101110111;

//     #5 test <= 12'b111101110000;
    

//     #10 $finish;
//   end

// endmodule: testSplit



