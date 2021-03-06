`default_nettype none

module Lab5
  (input logic [1:0] CoinValue,
  input logic CoinInserted, StartGame, 
  input logic [11:0] Guess, 
  input logic GradeIt,
  input logic [2:0] LoadShape,
  input logic [1:0] ShapeLocation,
  input logic LoadShapeNow,
  output logic [3:0] Znarly, Zood, RoundNumber, NumGames,
  output logic GameWon,
  input logic reset, clock,
  output logic loadNumGames, loadGuess, loadZnarlyZood,
  output logic clearGame, displayMasterPattern,
  output logic [11:0] masterPatternOut);



  logic guessChange, znarlyChange, zoodChange, numGamesChange;
  
  logic ongoingGame, loadingShape, doneGrading;
  logic drop; // whether game was paid for
  logic [3:0] credit; // leftover money (not used)
  logic [11:0] masterPattern;
  logic masterLoaded;

  
  assign loadGuess = (!loadingShape && guessChange) ? 1 : 0;
  
  assign loadZnarlyZood = doneGrading;
  assign masterPatternOut = masterPattern; //masterPatternOut will go to the VGA
  assign displayMasterPattern = ongoingGame; //connect displayMasterPattern out to ongoingGame logic
  //assign loadNumGames = drop; //connect loadNumGames to the Enable signal of gameCounter
  assign clearGame = 0;//StartGame; //Since StartGame refreshes the game, we can use it for the clearGame signal
    
  gameFSM game(reset, clock, StartGame, LoadShapeNow, masterLoaded, GameWon, NumGames, RoundNumber, ongoingGame, loadingShape, gameStarting);

  /*module gameFSM
  (input logic reset, clock, 
  input logic startGame, masterLoaded, gradeIt, finishedGrading,
  input logic [2:0] ZnarlyCount,
  input logic [3:0] NumGames, RoundNumber,
  output logic startLoadMasterPattern, startLoadPlayerGuess,
  output logic gradeGuess, GameWon, decrementNumGames); */

  logic circle, triangle, pent;

  change #(4) (clock, Znarly, znarlyChange);
  change #(12) (clock, Guess, guessChange);
  change #(1) (clock, NumGames, loadNumGames);
  
  myCoinFSM mydesign(CoinValue, drop,clock, ~reset, CoinInserted ); //input  logic  [1:0] CoinValue, output logic drop, input  logic clock, reset_N, coinInserted);   

	
  logic gameStarting;

  gameCounter # (4) gameCount (4'b0, !ongoingGame, drop | gameStarting, reset, 1'b0, clock, NumGames);//en => drop

  counter # (4) roundCounter (4'b0, 1'b1, (ongoingGame && doneGrading && !loadingShape), reset, 1'b0, clock, RoundNumber);

  loadMasterPattern loadMaster(LoadShape, ShapeLocation, loadingShape, StartGame, clock, masterPattern, masterLoaded);

  guessChecking guessCheck (ongoingGame, RoundNumber < 8, loadingShape, clock, doneGrading, Guess, masterPattern, Znarly, Zood,GameWon);

endmodule: Lab5


module gameFSM
  (input logic reset, clock, 
  input logic startGame, masterLoaded, gradeIt, finishedGrading,
  input logic [2:0] ZnarlyCount,
  input logic [3:0] NumGames, RoundNumber,
  output logic startLoadMasterPattern, startLoadPlayerGuess,
  output logic gradeGuess, GameWon, decrementNumGames);

  enum logic [1:0] {Waiting = 2'b00, LoadingMaster = 2'b01, PlayerGuess = 2'b10, Grading = 2'b11} state, nextState;

  always_ff @(posedge clock)
    if (reset) state <= Waiting;
    else state <= nextState;

  always_comb
  unique case(state)
    Waiting:
	begin
	  nextState = (startGame && NumGames > 0) ? LoadingMaster : Waiting;
	  startLoadMasterPattern = (startGame && NumGames > 0) ? 1 : 0;
	  startLoadPlayerGuess = 0;
	  gradeGuess = 0;
	  GameWon = 0;
	  decrementNumGames = 0;
	end
	LoadingMaster:
	begin
	  nextState = (masterLoaded) ? PlayerGuess : LoadingMaster;
	  startLoadMasterPattern = (masterLoaded) ? 0 : 1;
	  startLoadPlayerGuess = masterLoaded;
	  gradeGuess = 0;
	  GameWon = 0;
	  decrementNumGames = 0;
	end
	PlayerGuess:
	begin
	  nextState = (gradeIt) ? Grading : PlayerGuess;
	  startLoadMasterPattern = 0;
	  startLoadPlayerGuess = (gradeIt) ? 0 : 1;
	  gradeGuess = (gradeIt) ? 1 : 0;
	  GameWon = 0;
	  decrementNumGames = 0;
	end
	Grading:
	begin
	  nextState = (!finishedGrading) ? Grading : (ZnarlyCount == 4 || RoundNumber < 8) ? Waiting : PlayerGuess;
	  startLoadMasterPattern = 0;
	  startLoadPlayerGuess = 0;
	  gradeGuess = (gradeIt) 0;
	  GameWon = (ZnarlyCount == 4) ? 1 : 0;
	  decrementNumGames = 1;
	end
  endcase

    
endmodule: gameFSM

module gameCounter
  # (parameter WIDTH = 30)
  (input logic [WIDTH-1 : 0] D,
   input logic up, en, reset, load, clock,
   output logic [WIDTH-1 : 0] Q);

  always_ff @ (posedge clock, posedge reset) begin
    //$monitor("D: %b, up: %b, en: %b, clear: %b, load: %b, Q: %b", D, up, en, clear, load, Q);
    if(reset)
        Q <= 0;
    else
    if(en)
        if(load)
          Q <= D;
        else 
          if(up) 
      			 begin
                  if(Q < 7)
                    Q <= Q + 1;
      			 end
          else
            Q <= (Q>0) ? Q-1 : 0;

  end
endmodule: gameCounter

module roundCounter
  # (parameter WIDTH = 30)
  (input logic [WIDTH-1 : 0] D,
   input logic up, en, reset, load, clock,
   output logic [WIDTH-1 : 0] Q);

  always_ff @ (posedge clock, posedge reset) begin
    //$monitor("D: %b, up: %b, en: %b, clear: %b, load: %b, Q: %b", D, up, en, clear, load, Q);
    if(reset)
        Q <= 0;
    else
    if(en)
        if(load)
          Q <= D;
        else 
          if(up) 
      			 begin
						if(Q > 8)
							Q <= 0;
                  Q <= Q + 1;
						 
      			 end
          else
            Q <= (Q>0) ? Q-1 : 0;

  end
endmodule: roundCounter




module loadMasterPattern
  (input  logic [2:0] LoadShape,
   input  logic [1:0] ShapeLocation,
   input  logic loadingShape, startGame, clock,
   output logic [11:0] masterPattern, 
	output logic masterLoaded);

  logic [11:0] inputMaster; //master pattern
  Register mastPatt (inputMaster, loadingShape, startGame , clock, masterPattern);

  //check if space at shape at ShapeLocation is empty
  logic [2:0] o3,o2,o1,o0;
  sliceInput slice (masterPattern, o3, o2, o1, o0);

  assign masterLoaded = (o3 != 0) && (o2 != 0) && (o1 != 0) && (o0 != 0);

  always_comb begin
    //$display("%b, %b, %b, %b, masterPattern: %b, inputMaster: %b", o3, o2, o1, o0, masterPattern, inputMaster);
    if(startGame)
      inputMaster = 12'b0;
    else
      if(loadingShape) begin
        inputMaster = masterPattern;
        unique case(ShapeLocation)
          2'b11 : inputMaster[11:9] = (o3 == 3'b0) ? LoadShape : inputMaster[11:9];
          2'b10 : inputMaster[8:6] = (o2 == 3'b0) ? LoadShape : inputMaster[8:6];
          2'b01 : inputMaster[5:3] = (o1 == 3'b0) ? LoadShape : inputMaster[5:3];
          2'b00 : inputMaster[2:0] = (o0 == 3'b0) ? LoadShape : inputMaster[2:0];
        endcase
      end
		else
			inputMaster = masterPattern;
  end
    



endmodule: loadMasterPattern

module guessChecking
(input logic ongoingGame, areRoundsLeft, loadingShape, clock, doneGrading,
 input logic [11:0] guess, masterPattern,
 output logic [3:0] ZnarlyCount, ZoodCount, 
 output logic GameWon);

  logic en;
  logic [3:0] fakeZood;
  logic [3:0] Znarly, Zood;
  
  assign en = ongoingGame && areRoundsLeft && !loadingShape;
  
  checkForZnarly checkZnarly(masterPattern, guess, Znarly, ongoingGame);
  checkForZood checkForZood(masterPattern, guess, clock, fakeZood);
  
  always_comb begin
    if(en)
      GameWon = (guess == masterPattern) ? 1 : 0;
    else
	  GameWon = 0;
  end
count4bitsZood cnt1(Zood, ZnarlyCount ,ZoodCount);
count4bits cnt2(Znarly,ZnarlyCount);


endmodule: guessChecking



module count4bits(
  input logic [3:0] in,
  output logic [3:0] out
  );

assign out = in[3] + in[2] + in[1] + in[0];

endmodule: count4bits

module count4bitsZood(
  input logic [3:0] in, ZnarlyCount,
  output logic [3:0] out
  );

assign out = in[3] + in[2] + in[1] + in[0] - ZnarlyCount;

endmodule: count4bitsZood

module checkForZnarly
  (input logic [11:0] masterPattern, Guess,
  output logic [3:0] Znarly, input logic en);

  logic [2:0] g3, g2, g1, g0;
  logic [2:0] o3, o2, o1, o0;
  
  sliceInput masterSlice (masterPattern,o3, o2, o1, o0);
  sliceInput guessSlice (Guess, g3, g2, g1, g0);

  assign Znarly = (en) ? {o3==g3, o2==g2, o1==g1, o0==g0} : 0;


  // MagComp #(3) slice3 (g3, o3, , Znarly[3], );
  // MagComp #(3) slice2 (g2, o2, , Znarly[2], );
  // MagComp #(3) slice1 (g1, o1, , Znarly[1], );
  // MagComp #(3) slice0 (g0, o0, , Znarly[0], );


endmodule: checkForZnarly

module checkForZood
  (input [11:0] masterPattern, guess,
   input  clock,
   output [3:0] Zood);

  logic [2:0] m3, m2, m1, m0;
  logic [2:0] g3, g2, g1, g0;

  sliceInput slice (masterPattern, m3, m2, m1, m0);
  sliceInput slice2 (guess, g3, g2, g1, g0);


  logic used3, used2, used1, used0;
  logic usedm3, usedm2, usedm1, usedm0;
  always_comb begin
      {used3, used2, used1, used0} = 4'b0;

      if(m3 == g3)
        used3 = 1;
      else if(m2 == g3)
        used2 = 1;
      else if(m1 == g3)
        used1 = 1;
      else if(m0 == g3)
        used0 = 1;

      if(m3 == g2 && !used3)
        used3 = 1;
      else if(m2 == g2 && !used2)
        used2 = 1;
      else if(m1 == g2 && !used1)
        used1 = 1;
      else if(m0 == g2 && !used0)
        used0 = 1;

      if(m3 == g1 && !used3)
        used3 = 1;
      else if(m2 == g1 && !used2)
        used2 = 1;
      else if(m1 == g1 && !used1)
        used1 = 1;
      else if(m0 == g1 && !used0)
        used0 = 1;

      if(m3 == g0 && !used3)
        used3 = 1;
      else if(m2 == g0 && !used2)
        used2 = 1;
      else if(m1 == g0 && !used1)
        used1 = 1;
      else if(m0 == g0 && !used0)
        used0 = 1;

      
  end



  assign Zood = {used3, used2, used1, used0};


endmodule: checkForZood

module sliceInput
  (input [11:0] in,
   output [2:0] out3, out2, out1, out0);

  assign {out3, out2, out1, out0} = in;
  
endmodule: sliceInput




    
