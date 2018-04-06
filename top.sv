`default_nettype none

module top
  (input logic SW[17:0], input logic KEY[3:0], input logic CLOCK_50,
  output logic [6:0] HEX3, HEX2, HEX1, HEX0,
  output logic LEDG[0],
  output logic [7:0] VGA_R, VGA_G, VGA_B,
  output logic VGA_BLANK_N, VGA_CLK, VGA_SYNC_N,
  output logic VGA_VS, VGA_HS);
  
  logic [3:0] znarlyHex, zoodHex, roundHex, gamesHex;

  
  //NEED TO SYNCHRONIZE KEY INPUTS
  always_ff @(posedge CLOCK_50, posedge KEY[0])
  
  
  
  
  Lab5 labBox(SW[17:16], KEY[1], KEY[2], SW[11:0], KEY[3], SW[2:0], SW[4:3],
    KEY[3],znarlyHex, zoodHex, roundHex, gamesHex, LEDG[0],
    KEY[0], SW[15], CLOCK_50);

  BCDtoSevenSegment znarlyBCD(znarlyHex, HEX3);
  BCDtoSevenSegment zoodBCD(zoodHex, HEX2);
  BCDtoSevenSegment roundBCD(roundHex, HEX1);
  BCDtoSevenSegment gamesBCD(gamesHex, HEX0);	 
  
  mastermindVGA ( CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N,
    VGA_CLK, VGA_SYNC_N, VGA_VS, VGA_HS,
    // game information
    gamesHex,
    input  logic        loadNumGames,
    // Items for a particular round
    roundHex,
    input  logic [11:0] guess,
    input  logic        loadGuess,
    znarlyHex, zoodHex,
    input  logic        loadZnarlyZood,
    input  logic        clearGame,
    // master patterns
    input  logic [11:0] masterPattern,
    input  logic        displayMasterPattern,
    // other
    input  logic        reset
    );


endmodule: top
