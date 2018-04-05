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

    	$monitor("Loadshape %b into %b location -> masterPattern: %b | loadingShape: %b startGame: %b masterLoaded: %b ", 
    		LoadShape, ShapeLocation, masterPattern, loadingShape, startGame, masterLoaded);
    	
		@(posedge clock);
		@(posedge clock);
    	LoadShape = 3'b001;
    	ShapeLocation = 2'b00;
    	startGame = 1;
    	loadingShape = 1;
    	@(posedge clock);
    	startGame = 0;
		@(posedge clock);
		@(posedge clock);

		@(posedge clock);
		@(posedge clock);
		@(posedge clock);

		$finish;


    end


endmodule: testLoadMasterPattern



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



