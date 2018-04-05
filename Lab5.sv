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
  input logic reset, debug, clock);


  logic ongoingGame, loadingShape;
  
  gameFSM game(StartGame, RoundNumber, NumGames, clock, reset, ongoingGame, loadingShape);
 // gradeFSM grade();

  logic drop; // whether game was paid for
  logic [3:0] credit; // leftover money (not used)

  myCoinFSM mydesign(CoinValue, drop, credit, CoinInserted, ~reset);

  // counter gameCounter ();

  // counter roundCounter ();

  // loadMasterPattern mast ();





endmodule: Lab5


module checkForZnarly
  (input logic [11:0] masterPattern, Guess,
  output logic [3:0] Znarly);

  logic [2:0] g3, g2, g1, g0;
  logic [2:0] o3, o2, o1, o0;
  
  sliceInput masterSlice (masterPattern,o3, o2, o1, o0);
  sliceInput guessSlice (Guess, g3, g2, g1, g0);

  MagComp #(3) slice3 (g3, o3, , Znarly[3], );
  MagComp #(3) slice2 (g2, o2, , Znarly[2], );
  MagComp #(3) slice1 (g1, o1, , Znarly[1], );
  MagComp #(3) slice0 (g0, o0, , Znarly[0], );

 /*
  always_comb 
  if (en)
	begin
    Znarly[3] = (g3 == o3) ? 1 : 0;
    Znarly[2] = (g2 == o2) ? 1 : 0;
    Znarly[1] = (g1 == o1) ? 1 : 0;
    Znarly[0] = (g0 == o0) ? 1 : 0;
	end
  else
	Znarly = 4'b1111;
  */

endmodule: checkForZnarly

module loadMasterPattern
  (input [2:0] LoadShape, 
   input [1:0] ShapeLocation,
   input loadingShape, startGame, clock,
   output [11:0] masterPattern, output masterLoaded);

  logic [11:0] inputMaster; //master pattern
  Register mastPatt (inputMaster, loadingShape, startGame , clock, masterPattern);

  //check if space at shape at ShapeLocation is empty
  logic [2:0] o3,o2,o1,o0;
  sliceInput slice (masterPattern, o3, o2, o1, o0);

  assign masterLoaded = (o3 != 0) && (o2 != 0) && (o1 != 0) && (o0 != 0);

  always_comb
    if(loadingShape)
      unique case(ShapeLocation)
        2'b11 : inputMaster[11:9] = (o3 == 0) ? LoadShape: 3'b0;
        2'b10 : inputMaster[8:6] = (o2 == 0) ? LoadShape: 3'b0;
        2'b01 : inputMaster[5:3] = (o1 == 0) ? LoadShape: 3'b0;
        2'b00 : inputMaster[2:0] = (o0 == 0) ? LoadShape: 3'b0;
      endcase
    

endmodule: loadMasterPattern

module sliceInput
  (input [11:0] in,
   output [2:0] out3, out2, out1, out0);

  assign {out3, out2, out1, out0} = in;
  
endmodule: sliceInput

module gameFSM
  (input logic StartGame,
  input logic [3:0] RoundNumber, NumGames,
  input logic clock, reset, GameWon,
  output logic ongoingGame); 

  enum logic [1:0] {WaitGame = 2'b00, PlayGame = 2'b01} gameCS, gameNS;

  always_ff @(posedge clock)
    if (reset) gameCS <= WaitGame;
    else gameCS <= gameNS;

  always_comb
	unique case(gameCS)
	  WaitGame: gameNS = (NumGames > 0 && StartGame) ? PlayGame : WaitGame;
    PlayGame: gameNS = (GameWon || RoundNumber >= 8) ? WaitGame : PlayGame;
	endcase

  always_comb
	unique case(gameCS)
	  WaitGame: ongoingGame = 0;
	  PlayGame: ongoingGame = 1;
	endcase
	  
endmodule: gameFSM


// module gradeFSM();

//   enum logic [1:0] {NotGraded = 2'b10 Grading = 2'b11} gradeCS, gradeNS;

//   always_ff @(posedge clock)
//     if (reset) gradeCS <= NotGraded;
//     else begin gradeCS <= gradeNS;

//   always_comb
// 	unique case(state)
// 	  NotGraded:
// 		begin
// 		gradeNS = (gradeIt) ? Grading : NotGraded; 
// 		doneGrading = 0;
// 		end
// 	  Grading:
// 		begin
// 		gradeNS = (gradeIt) ? Grading : NotGraded;
// 		doneGrading = (gradeIt) ? 0 : 1;
// 		end
// 	endcase

// endmodule: gradeFSM



    
