`default_nettype none


module testCheckGuessing();

logic ongoingGame, areRoundsLeft, loadingShape, clock, doneGrading;
logic [11:0] guess, masterPattern;

logic [3:0] ZnarlyCount, ZoodCount;
logic GameWon;

guessChecking check(.*);

initial begin
	clock = 0;
	forever #5 clock = ~clock;

end

initial begin

	$monitor("guess: %b, master: %b, Znarly: %b, Zood: %b, GameWon: %b", guess, masterPattern, ZnarlyCount, ZoodCount, GameWon);
	ongoingGame = 1;
	areRoundsLeft = 1;
	loadingShape = 0;
	doneGrading = 0;
	guess = 12'b001001010010;
	masterPattern = 12'b101110100001;

	@(posedge clock);
	@(posedge clock);
	masterPattern = 12'b101110100001;
	guess = 12'b011011100100;//OODD /Znarly
	@(posedge clock);
	guess = 12'b101101010010;//IICC /Znarly
	@(posedge clock);
	guess = 12'b101011001110;//IOTZ /Znarly 2 - Zood
	@(posedge clock);
	guess = 12'b001101110100;//TIZD / 4 - Zood
	@(posedge clock);
	guess = 12'b101110100001;//IZDT / 4 - Zood
	@(posedge clock);



	$finish;

end

endmodule: testCheckGuessing

// module testCheckForZood();


// logic [11:0] masterPattern, guess;
// logic clock;
// logic [3:0] Zood;
// logic check;

// checkForZood checkZood(masterPattern, guess, clock, Zood);

// initial begin
// 	clock = 0;
// 	forever #5 clock = ~clock;

// end

// initial begin

// 	$monitor("masterPattern %b guess %b => zood %b | check : %b", masterPattern, guess, Zood, check);
	
// 	@(posedge clock);
// 	@(posedge clock);
// 	masterPattern = 12'b101110100001;
// 	guess = 12'b011011100100;//OODD /Znarly
// 	@(posedge clock);
// 	guess = 12'b101101010010;//IICC /Znarly
// 	@(posedge clock);
// 	guess = 12'b101011001110;//IOTZ /Znarly 2 - Zood
// 	@(posedge clock);
// 	guess = 12'b001101110100;//TIZD / 4 - Zood
// 	@(posedge clock);


// 	$finish;


// end

// endmodule: testCheckForZood
// module testLoadMasterPattern();


//     logic [2:0] LoadShape; 
//     logic [1:0] ShapeLocation;
//     logic loadingShape, startGame, clock;
//     logic [11:0] masterPattern; logic masterLoaded;


//     loadMasterPattern loadMaster(LoadShape, ShapeLocation, loadingShape, startGame, clock, masterPattern, masterLoaded);

//     initial begin
//     	clock = 0;
//     	forever #5 clock = ~clock;
//     end

//     initial begin

//     	$monitor("Loadshape %b into %b location -> masterPattern: %b | loadingShape: %b startGame: %b masterLoaded: %b ", 
//     		LoadShape, ShapeLocation, masterPattern, loadingShape, startGame, masterLoaded);
    	
// 		@(posedge clock);
// 		@(posedge clock);
//     	LoadShape = 3'b001;
//     	ShapeLocation = 2'b00;
//     	startGame = 1;
//     	loadingShape = 1;
//     	@(posedge clock);
//     	startGame = 0;
// 		@(posedge clock);
// 		LoadShape = 3'b001;
//     	ShapeLocation = 2'b01;
// 		@(posedge clock);
// 		LoadShape = 3'b001;
//     	ShapeLocation = 2'b10;
// 		@(posedge clock);
// 		LoadShape = 3'b001;
//     	ShapeLocation = 2'b11;
// 		@(posedge clock);
// 		LoadShape = 3'b010;
//     	ShapeLocation = 2'b00;
// 		@(posedge clock);
// 		LoadShape = 3'b100;
//     	ShapeLocation = 2'b00;

// 		$finish;


//     end


// endmodule: testLoadMasterPattern



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



