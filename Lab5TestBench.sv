`default_nettype none


module testCoinAcceptor();


	logic [1:0] CoinValue; 
	logic CoinInserted, Drop, reset_n, clock;

	myCoinFSM accept(CoinValue, Drop, clock, reset_n, CoinInserted);



	initial begin
		reset_n = 0;
		reset_n <= 1;
		clock = 0;
		forever #5 clock = ~clock;
	end 

	initial begin
		$monitor("CoinValue:%b, CoinInserted:%b, Drop: %b, reset: %b", CoinValue, CoinInserted, Drop, reset_n);
		//initialize values
		CoinValue <= 2'b0; CoinInserted <= 1'b0;

		@(posedge clock);
		CoinValue <= 2'b01;
		CoinInserted <= 1;
		@(posedge clock);
		CoinInserted <= 1;
		@(posedge clock);
		CoinInserted <= 1;
		@(posedge clock);
		CoinInserted <= 1;
		@(posedge clock);
		CoinInserted <= 1;

		@(posedge clock);
		CoinInserted <= 0;

		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		CoinValue = 2'b10;
		CoinInserted = 1;
		@(posedge clock);
		CoinInserted = 0;

		@(posedge clock);
		@(posedge clock);
				@(posedge clock);
		CoinValue = 2'b11;
		CoinInserted = 1;
		@(posedge clock);
		CoinInserted = 0;

		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		CoinValue = 2'b01;
		CoinInserted = 1;
		@(posedge clock);
		CoinInserted = 0;

		@(posedge clock);
		@(posedge clock);

		@(posedge clock);
		CoinValue = 2'b01;
		CoinInserted = 1;
		@(posedge clock);
		CoinInserted = 0;

		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		CoinValue = 2'b01;
		CoinInserted = 1;
		@(posedge clock);
		CoinInserted = 0;

		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		CoinValue = 2'b01;
		CoinInserted = 1;
		@(posedge clock);
		CoinInserted = 0;

		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		CoinValue = 2'b01;
		CoinInserted = 1;
		@(posedge clock);
		CoinInserted = 0;

		@(posedge clock);
		@(posedge clock);

		$finish;

	end

endmodule: testCoinAcceptor

// module testLab5();


//   logic [1:0] CoinValue;
//   logic CoinInserted, StartGame;
//   logic [11:0] Guess;
//   logic GradeIt;
//   logic [2:0] LoadShape;
//   logic [1:0] ShapeLocation;
//   logic LoadShapeNow;
  
//   logic [3:0] Znarly, Zood, RoundNumber, NumGames;
//   logic GameWon;

//   logic reset, debug, clock;

//   Lab5 test(.*);

// 	initial begin
// 		clock = 0;
// 		forever #5 clock = ~clock;

// 	end 

// 	initial begin

// 		$monitor("CoinValue:%b, CoinInserted:%b, StartGame:%b, Guess:%b, GradeIt:%b, LoadShape:%b, \
// 			      ShapeLocation:%b, LoadShapeNow:%b, Znarly:%b, Zood:%b, RoundNumber:%b, NumGames:%b \
// 			      GameWon:%b, reset: %b, debug:%b ", CoinValue, CoinInserted, StartGame, Guess, GradeIt,
// 			      LoadShape, ShapeLocation, LoadShapeNow, Znarly, Zood, RoundNumber, NumGames, GameWon,
// 			      reset, debug);

// 		$monitor("",);
// 		//initialize values
// 		CoinValue = 2'b0; CoinInserted = 1'b0;
// 		StartGame = 1'b0; Guess = 12'b0; GradeIt = 1'b0;
// 		LoadShape = 1'b0; ShapeLocation = 2'b0; LoadShapeNow = 1'b0;
// 		reset = 1'b0; debug = 1'b0;

// 		@(posedge clock);
// 		reset <= 1;

// 		@(posedge clock);
// 		reset <= 0; //reset game

// 		@(posedge clock);
// 		CoinValue = 2'b10;
// 		CoinInserted = 1;
// 		@(posedge clock);
// 		CoinInserted = 0;
// 		@(posedge clock);
// 		CoinInserted = 1;
// 		@(posedge clock);
// 		CoinInserted = 0;
// 		@(posedge clock);
// 		CoinInserted = 1;
// 		@(posedge clock);
// 		CoinInserted = 0;
// 		@(posedge clock);
// 		CoinInserted = 1;
// 		@(posedge clock);
// 		CoinInserted = 0;
// 		@(posedge clock);
// 		CoinInserted = 1;
// 		@(posedge clock);
// 		CoinInserted = 0;
// 		@(posedge clock);
// 		CoinInserted = 1;
// 		@(posedge clock);
// 		CoinInserted = 0;
// 		@(posedge clock);
// 		CoinInserted = 1;
// 		@(posedge clock);
// 		CoinInserted = 0;
// 		@(posedge clock);
// 		CoinInserted = 1;
// 		@(posedge clock);
// 		CoinInserted = 0;
// 		@(posedge clock);
// 		CoinInserted = 1;
// 		@(posedge clock);
// 		CoinInserted = 0;

// 		// @(posedge clock);
// 		// CoinInserted = 0;

// 		// @(posedge clock);
// 		// CoinValue = 2'b11;
// 		// CoinInserted = 1;
// 		// @(posedge clock);
// 		// CoinInserted = 0;
// 		// @(posedge clock);
// 		// @(posedge clock);
// 		// CoinValue = 2'b11;
// 		// CoinInserted = 1;
// 		// @(posedge clock);
// 		// CoinInserted = 0;
// 		// @(posedge clock);
// 		// CoinValue = 2'b11;
// 		// CoinInserted = 1;
// 		// @(posedge clock);
// 		// CoinInserted = 0;
// 		// @(posedge clock);

// 		// CoinValue = 2'b01;
// 		// CoinInserted = 1;

// 		$finish;




// 	end


//  endmodule

// module testCheckGuessing();

// logic ongoingGame, areRoundsLeft, loadingShape, clock, doneGrading;
// logic [11:0] guess, masterPattern;

// logic [3:0] ZnarlyCount, ZoodCount;
// logic GameWon;

// guessChecking check(.*);

// initial begin
// 	clock = 0;
// 	forever #5 clock = ~clock;

// end

// initial begin

// 	$monitor("guess: %b, master: %b, Znarly: %b, Zood: %b, GameWon: %b", guess, masterPattern, ZnarlyCount, ZoodCount, GameWon);
// 	ongoingGame = 1;
// 	areRoundsLeft = 1;
// 	loadingShape = 0;
// 	doneGrading = 0;
// 	guess = 12'b001001010010;
// 	masterPattern = 12'b101110100001;

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
// 	guess = 12'b101110100001;//IZDT / 4 - Zood
// 	@(posedge clock);



// 	$finish;

// end

// endmodule: testCheckGuessing

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



// module testGameFSM;
//   logic reset, clock;
//   logic startGame, loadShapeNow, allShapesLoaded, gameWon;
//   logic [4:0] NumGames, RoundNumber, counter;
//   logic ongoingGame, loadingShape;
 
//   gameFSM game(.*);

//   initial begin
//     clock = 0;
//     forever #5 clock = ~clock;
//   end

//   initial begin
// 	$monitor("%s, reset %b, startGame: %b, loadShapeNow: %b, allShapesLoaded: %b, gameWon: %b, NumGames: %d, RoundNumber: %d",
//     game.state.name, reset, startGame, loadShapeNow, allShapesLoaded, gameWon, NumGames, RoundNumber);
// 	reset <= 1;
// 	startGame <= 0; loadShapeNow <= 0; allShapesLoaded <= 0; gameWon <= 0;
// 	NumGames <= 5'd0; RoundNumber <= 5'd0;
// 	@(posedge clock);
// 	reset <= 0;

// 	//make sure that state doesn't change when NumGames < 1;
// 	@(posedge clock);
// 	startGame <= 1;
//     @(posedge clock);
// 	//make sure state changes when NumGames > 0 and startGame = 1;
// 	startGame <= 0; NumGames <= 5'd1;
// 	@(posedge clock);
// 	startGame <= 1;
// 	//change state to StartingGame and then to LoadShape
// 	@(posedge clock);
// 	loadShapeNow <= 1;
// 	//change state to LoadShape and then to Guess
// 	@(posedge clock);
// 	allShapesLoaded <= 1;
// 	@(posedge clock);
// 	//change state to Guess and increment RoundNumber until hitting WaitGame
// 	for(counter = 5'd0; counter < 5'd10; counter++)
// 	RoundNumber <= counter;
// 	@(posedge clock);
// 	startGame <= 0;
// 	@(posedge clock);
//   	$finish;
//   end

// endmodule: testGameFSM

// module testGradeFSM;

//  logic reset, clock, gradeIt, doneGrading;

//   gradeFSM grade(.*);

//   initial begin
//     clock = 0;
//     forever #5 clock = ~clock;
//   end

//   initial begin
// 	$monitor("%s, reset %b, gradeIt %b, doneGrading %b",
//     grade.state.name, reset, gradeIt, doneGrading);
// 	reset <= 1;
// 	gradeIt <= 0;
// 	@(posedge clock);
// 	reset <= 0;
// 	@(posedge clock);
// 	@(posedge clock);
// 	gradeIt <= 1;
// 	@(posedge clock);
// 	@(posedge clock);
// 	gradeIt <= 0;
// 	@(posedge clock);
// 	@(posedge clock);
// 	gradeIt <= 1;
// 	@(posedge clock);
// 	@(posedge clock);

// 	$finish;
//   end

// endmodule: testGradeFSM

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



