`default_nettype none

module dFlipFlop(
	output logic q,
    input  logic d, clock, reset_N);

    always @(posedge clock)
    	if (reset_N == 0)       
    	  	q <= 0;      
    	else       
    		q <= d;
endmodule: dFlipFlop


module myCoinFSM(   
	input  logic 	   circ, triangle, pent,   
	output logic       drop,  
	output logic [3:0] credit,  
	input  logic       clock, reset_N);   

	// interconnect wires.  Add more if needed
	enum logic [3:0] {state0 = 4'b0000, state1 = 4'b0001, state2 = 4'b0010,
					  state3 = 4'b0011, state4 = 4'b0100, state5 = 4'b0101,
					  state6 = 4'b0110, state7 = 4'b0111, wstate0 = 4'b1000,
					  wstate1 = 4'b1001, wstate2 = 4'b1010, wstate3 = 4'b1011,
					  wstate4 = 4'b1100, wstate5 = 4'b1101, wstate6 = 4'b1110,
					  wstate7 = 4'b1111} state, nextState;

	always @(posedge clock)
    	if (reset_N == 0)       
    	  	state <= state0;      
    	else       
    		state <= nextState;

	// Next state logic goes here: combinational logic that   
	// drives next state (d0, etc) based upon input coin and   
	// the current state (q0, q1, etc).

	always_comb begin
		case (state)
			state0: if (circ) nextState = wstate1;
					else if (triangle) nextState = wstate3;
					else if (pent) nextState = wstate5;
					else nextState = wstate0;
			state1: if (circ) nextState = wstate2;
					else if (triangle) nextState = wstate4;
					else if (pent) nextState = wstate6;
					else nextState = wstate1;
			state2: if (circ) nextState = wstate3;
					else if (triangle) nextState = wstate5;
					else if (pent) nextState = wstate7;
					else nextState = wstate2;
			state3: if (circ) nextState = wstate4;
					else if (triangle) nextState = wstate6;
					else if (pent) nextState = wstate4;
					else nextState = wstate3;
			state4: if (circ) nextState = wstate1;
					else if (triangle) nextState = wstate3;
					else if (pent) nextState = wstate5;
					else nextState = wstate4;
			state5: if (circ) nextState = wstate2;
					else if (triangle) nextState = wstate4;
					else if (pent) nextState = wstate6;
					else nextState = wstate5;
			state6: if (circ) nextState = wstate3;
					else if (triangle) nextState = wstate5;
					else if (pent) nextState = wstate7;
					else nextState = wstate6;
			state7: if (circ) nextState = wstate4;
					else if (triangle) nextState = wstate6;
					else if (pent) nextState = wstate4;
					else nextState = wstate7;
			wstate0: if (~circ && ~triangle && ~pent) nextState = state0;
				 else nextState = wstate0;
			wstate1: if (~circ && ~triangle && ~pent) nextState = state1;
				 else nextState = wstate1;
			wstate2: if (~circ && ~triangle && ~pent) nextState = state2;
				 else nextState = wstate2;
			wstate3: if (~circ && ~triangle && ~pent) nextState = state3;
				 else nextState = wstate3;
			wstate4: if (~circ && ~triangle && ~pent) nextState = state4;
				 else nextState = wstate4;
			wstate5: if (~circ && ~triangle && ~pent) nextState = state5;
				 else nextState = wstate5;
			wstate6: if (~circ && ~triangle && ~pent) nextState = state6;
				 else nextState = wstate6;
			wstate7: if (~circ && ~triangle && ~pent) nextState = state7;
				 else nextState = wstate7;

		endcase
	end

	// Your output logic goes here: combinational logic that   
	// drives drop and credit based upon current state (q0, etc).   
	always_comb 
	begin
		//$monitor("credit: %b, drop; %b", credit, drop);
		credit[0] = state[0];
		credit[1] = state[1];
		credit[2] = 0; 
		credit[3] = 0;
		drop = state[2];
	end 

endmodule: myCoinFSM 


// module top();

//   logic drop;
//   logic [3:0] credit;
//   logic [1:0] coin;
//   logic clock, reset_N;

//   // myStructuralFSM mydesign(coin, drop, credit, clock, reset_N);
//   // fsmtestbench tester(drop, mydesign.q2, mydesign.q1,
//   // 				mydesign.q0, credit, coin, clock, reset_N);
//   myEnumeratedFSM mydesign(coin, drop, credit, clock, reset_N);
//   // fsmtestbench tester(drop, mydesign.state[2], mydesign.state[1],
//   // 				mydesign.state[0], credit, coin, clock, reset_N);
// endmodule: top
