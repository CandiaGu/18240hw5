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


  logic ongoingGame, loadingShape, doneGrading;
  logic drop; // whether game was paid for
  logic [3:0] credit; // leftover money (not used)
  logic [11:0] masterPattern;

  assign masterPatternOut = masterPattern; //masterPatternOut will go to the VGA
  assign displayMasterPattern = ongoingGame; //connect displayMasterPattern out to ongoingGame logic
  assign loadNumGames = drop; //connect loadNumGames to the Enable signal of gameCounter
  assign loadZnarlyZood = doneGrading; //connect loadZnarlyZood signal to the doneGrading signal from gradeFSM
  assign loadGuess = GradeIt; //GradeIt tells the game to load a player's guess
  assign clearGame = StartGame; //Since StartGame refreshes the game, we can use it for the clearGame signal
    
  gameFSM game(reset, clock, startGame, loadShapeNow, allShapesLoaded, gameWon, NumGames, RoundNumber, ongoingGame, loadingShape);
  gradeFSM grade(reset, clock, GradeIt, doneGrading);

  myCoinFSM mydesign(CoinValue, drop, credit, CoinInserted, ~reset);

  gameCounter # (4) gameCount (4'd0, !ongoingGame, drop, reset, 0, clock, NumGames);
  counter # (4) roundCounter (4'd0, 1, (ongoingGame && doneGrading && !loadingShape), 0, startGame, clock, RoundNumber);

  loadMasterPattern loadMaster(LoadShape, ShapeLocation, loadingShape, startGame, clock, masterPattern, masterLoaded);

  guessChecking guess (ongoingGame, RoundNumber < 8, loadingShape, clock, doneGrading, guess, masterPattern, ZnarlyCount, ZoodCount,GameWon);

endmodule: Lab5


module gameCounter
  # (parameter WIDTH = 30)
  (input logic [WIDTH-1 : 0] D,
   input logic up, en, clear, load, clock,
   output logic [$clog2(WIDTH)-1 : 0] Q);

  always_ff @ (posedge clock, posedge clear)
    if(en)
      if(clear)
        Q <= 0;
      else 
        if(load)
          Q <= D;
        else 
          if(up)
            if(Q < 7)
              Q <= Q + 1;
          else
            Q <= (Q>0) ? Q-1 : 0;
endmodule: counter



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

  always_comb begin
    $display("%b, %b, %b, %b, masterPattern: %b, inputMaster: %b", o3, o2, o1, o0, masterPattern, inputMaster);
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

checkForZnarly checkZnarly(masterPattern, guess, Znarly);
checkForZood checkForZood(masterPattern, guess, clock, fakeZood);

always_comb begin
  if(en)
    GameWon = guess == masterPattern;
  Zood = fakeZood & ~(Znarly);
end

count4bits cnt1(Zood,ZoodCount);
count4bits cnt2(Znarly,ZnarlyCount);


endmodule: guessChecking



module count4bits(
  input logic [3:0] in,
  output logic [3:0] out
  );

assign out = in[3] + in[2] + in[1] + in[0];

endmodule: count4bits

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


endmodule: checkForZnarly

module checkForZood
  (input [11:0] masterPattern, guess,
   input  clock,
   output [3:0] Zood);

  logic [2:0] m3, m2, m1, m0;
  logic [2:0] g3, g2, g1, g0;

  sliceInput slice (masterPattern, m3, m2, m1, m0);
  sliceInput slice2 (guess, g3, g2, g1, g0);

  //logic c3, c2, c1, c0;

  //Register #(4) checkedZood({c3, c2, c1, c0}, 1'b1, 1'b0 , clock, Zood);


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

      $display("zood2 : %b", {used3, used2, used1, used0});

      
  end



  assign Zood = {used3, used2, used1, used0};


endmodule: checkForZood

module sliceInput
  (input [11:0] in,
   output [2:0] out3, out2, out1, out0);

  assign {out3, out2, out1, out0} = in;
  
endmodule: sliceInput



module gameFSM
  (input logic reset, clock, 
  input logic startGame, loadShapeNow, allShapesLoaded, gameWon,
  input logic [4:0] NumGames, RoundNumber,
  output logic ongoingGame, loadingShape);

  enum logic [1:0] {WaitGame = 2'b00, StartingGame = 2'b01, LoadShape = 2'b10, Guess = 2'b11 } state, nextState;

  always_ff @(posedge clock)
    if (reset) state <= WaitGame;
    else state <= nextState;

  always_comb
  unique case(state)
    WaitGame: 
    begin
    nextState = (NumGames > 0 && startGame) ? StartingGame : WaitGame;
    ongoingGame = (NumGames > 0 && startGame) ? 1: 0; loadingShape = 0;
    end
    StartingGame:
    begin
    nextState = (loadShapeNow) ? LoadShape : StartingGame;
    ongoingGame = 1; loadingShape = (loadShapeNow) ? 1 : 0;
    end
    LoadShape:
    begin
    nextState = (allShapesLoaded) ? Guess : LoadShape;
    ongoingGame = 1; loadingShape = (allShapesLoaded) ? 0 : 1;
    end
    Guess:
    begin
    nextState = (gameWon || RoundNumber >= 8) ?  WaitGame : Guess;
    ongoingGame = (gameWon || RoundNumber >= 8) ? 0 : 1; loadingShape = 0;
    end
  endcase

    
endmodule: gameFSM

module gradeFSM
  (input logic reset, clock, GradeIt,
  output logic doneGrading);

  enum logic [1:0] {notGraded = 2'b10, grading = 2'b11} state, nextState;

  always_ff @(posedge clock)
  if (reset) state <= notGraded;
    else state <= nextState;

  always_comb
  unique case(state)
    notGraded:
    begin
      nextState = (GradeIt) ? grading : notGraded;
      doneGrading = 0;
    end 
    grading: 
    begin
    nextState = (GradeIt) ? grading: notGraded;
    doneGrading = (GradeIt) ? 0 : 1;
    end
  endcase

endmodule: gradeFSM


    
