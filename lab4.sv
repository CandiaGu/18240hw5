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
	input  logic [1:0] coin,   
	output logic       drop,  
	output logic [3:0] credit,  
	input  logic       clock, reset_N);   

	// interconnect wires.  Add more if needed   
	enum logic [2:0] {state0 = 3'b000, state1 = 3'b001, state2 = 3'b010,
					  state3 = 3'b011, state4 = 3'b100, state5 = 3'b101,
					  state6 = 3'b110, state7 = 3'b111} state, nextState;

	always @(posedge clock)
    	if (reset_N == 0)       
    	  	state <= state0;      
    	else       
    		state <= nextState;
    		// if (drop == 1) // set drop to 1 only for one clock cycle
    		// 	drop = 0;

	// Next state logic goes here: combinational logic that   
	// drives next state (d0, etc) based upon input coin and   
	// the current state (q0, q1, etc).

	always_comb begin
		case (state)
			state0: if (coin == 2'b00) nextState = state0;
					else if (coin == 2'b01) nextState = state1;
					else if (coin == 2'b10) nextState = state3;
					else nextState = state5;
			state1: if (coin == 2'b00) nextState = state1;
					else if (coin == 2'b01) nextState = state2;
					else if (coin == 2'b10) nextState = state4;
					else nextState = state6;
			state2: if (coin == 2'b00) nextState = state2;
					else if (coin == 2'b01) nextState = state3;
					else if (coin == 2'b10) nextState = state5;
					else nextState = state7;
			state3: if (coin == 2'b00) nextState = state3;
					else if (coin == 2'b01) nextState = state4;
					else if (coin == 2'b10) nextState = state6;
					else nextState = state4;
			state4: if (coin == 2'b00) nextState = state4;
					else if (coin == 2'b01) nextState = state1;
					else if (coin == 2'b10) nextState = state3;
					else nextState = state5;
			state5: if (coin == 2'b00) nextState = state5;
					else if (coin == 2'b01) nextState = state2;
					else if (coin == 2'b10) nextState = state4;
					else nextState = state6;
			state6: if (coin == 2'b00) nextState = state6;
					else if (coin == 2'b01) nextState = state3;
					else if (coin == 2'b10) nextState = state5;
					else nextState = state7;
			state7: if (coin == 2'b00) nextState = state7;
					else if (coin == 2'b01) nextState = state4;
					else if (coin == 2'b10) nextState = state6;
					else nextState = state4;
		endcase
	end

	// Your output logic goes here: combinational logic that   
	// drives drop and credit based upon current state (q0, etc).   
	always_comb 
	begin
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
