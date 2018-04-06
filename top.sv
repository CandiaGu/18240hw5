`default_nettype none

module top
  (input logic SW[17:0], input logic KEY[3:0], input logic CLOCK_50,
  output logic [6:0] HEX3, HEX2, HEX1, HEX0,
  output logic LEDG[0],
  output logic [7:0] VGA_R, VGA_G, VGA_B,
  output logic VGA_BLANK_N, VGA_CLK, VGA_SYNC_N,
  output logic VGA_VS, VGA_HS);
  
  logic [3:0] znarlyHex, zoodHex, numRoundHex, numGamesHex;

  logic reset;
  logic [17:0] SW1, SW2;
  logic [3:0] KEY1, KEY2;
  
  assign reset = KEY[0];
  
  
  //Synchronize SWITCH inputs to clock
  always_ff @(posedge CLOCK_50, posedge reset)
	if (reset) begin
	  SW1 <= 0;
	  SW2 <= 0;
    end else begin
	  SW1 <= SW;
	  SW2 <= SW1;
	end
  end
  
  //Synchronize SWITCH inputs to clock
  always_ff @(posedge CLOCK_50, posedge reset)
	if (reset) begin
	  KEY1 <= 0;
	  KEY2 <= 0;
    end else begin
	  KEY1 <= KEY;
	  KEY2 <= KEY1;
	end
  end
  
  //VGADisplayMasterPattern connects the displayMasterPattern output from Lab5 with the debug switch
  //if the debug switch is on or Lab 5 outputs displayMasterPattern, the VGA will take that as 1 
  logic VGADisplayMasterPattern, Lab5DisplayMasterPattern; 
  assign VGADisplayMatterPattern == SW2[15] || Lab5DisplayMasterPattern;

  logic loadNumberGames; //connect loadNumGames out of Lab 5 to loadNumGames in of VGA
  logic loadZnarlyAndZood; //connect loadZnarlyZood out from Lab 5 to loadZnarlyZood in of VGA
  logic LoadGuess; //connect loadGuess out from Lab 5 to loadGuess in of VGA
  logic ClearGame; //connect clearGame out from Lab 5 to clearGame in of VGA
  logic [11:0] LabtoVGAMasterPattern; //connect masterPattern from Lab 5 to VGA
  
  Lab5 labBox(SW2[17:16], KEY2[1], KEY2[2], SW2[11:0], KEY2[3], SW2[2:0], SW2[4:3],
    KEY2[3],znarlyHex, zoodHex, numRoundHex, numGamesHex, LEDG[0],
    reset, CLOCK_50,
   .loadNumGames(loadNumberGames), .loadGuess(LoadGuess),
   .displayMasterPattern(Lab5DisplayMasterPattern),
   .loadZnarlyZood(loadZnarlyAndZood),
   .clearGame(ClearGame),
   .masterPatternOut(LabtoVGAMasterPattern));

  BCDtoSevenSegment znarlyBCD(znarlyHex, HEX3);
  BCDtoSevenSegment zoodBCD(zoodHex, HEX2);
  BCDtoSevenSegment roundBCD(numRoundHex, HEX1);
  BCDtoSevenSegment gamesBCD(numGamesHex, HEX0);	 
  
  mastermindVGA ( CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N,
    VGA_CLK, VGA_SYNC_N, VGA_VS, VGA_HS,
    // game information
    numGamesHex,
    loadNumberGames,
    // Items for a particular round
    numRoundHex,
    .guess(SW2[11:0]),
    LoadGuess,
    znarlyHex, zoodHex,
    loadZnarlyAndZood,
    ClearGame,
    // master patterns
    LabtoVGAMasterPattern,
    VGADisplayMasterPattern,
    // other
    reset);


endmodule: top
