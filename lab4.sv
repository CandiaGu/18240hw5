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
	input  logic  [1:0] CoinValue,
	output logic       drop,    
	input  logic       clock, reset_N, coinInserted);   

	// interconnect wires.  Add more if needed
	enum logic [3:0] {state0 = 4'b0000, state1 = 4'b0001, state2 = 4'b0010,
					  state3 = 4'b0011, state4 = 4'b0100, state5 = 4'b0101,
					  state6 = 4'b0110, state7 = 4'b0111, wstate0 = 4'b1000,
					  wstate1 = 4'b1001, wstate2 = 4'b1010, wstate3 = 4'b1011,
					  wstate4 = 4'b1100, wstate5 = 4'b1101, wstate6 = 4'b1110,
					  wstate7 = 4'b1111} state, nextState;

	always @(posedge clock, negedge reset_N)
    	if (reset_N == 0)
    	  	state <= state0;      
    	else begin
    		state <= nextState;

    	end
	// Next state logic goes here: combinational logic that   
	// drives next state (d0, etc) based upon input coin and   
	// the current state (q0, q1, etc).

	always_comb begin
		case (state)
			state0: if (CoinValue == 2'b01 && coinInserted) nextState = wstate1;
					else if (CoinValue == 2'b10 && coinInserted) nextState = wstate3;
					else if (CoinValue == 2'b11 && coinInserted) nextState = wstate5;
					else nextState = wstate0;
			state1: if (CoinValue == 2'b01 && coinInserted) nextState = wstate2;
					else if (CoinValue == 2'b10 && coinInserted) nextState = wstate4;
					else if (CoinValue == 2'b11 && coinInserted) nextState = wstate6;
					else nextState = wstate1;
			state2: if (CoinValue == 2'b01 && coinInserted) nextState = wstate3;
					else if (CoinValue == 2'b10 && coinInserted) nextState = wstate5;
					else if (CoinValue == 2'b11 && coinInserted) nextState = wstate7;
					else nextState = wstate2;
			state3: if (CoinValue == 2'b01 && coinInserted) nextState = wstate4;
					else if (CoinValue == 2'b10 && coinInserted) nextState = wstate6;
					else if (CoinValue == 2'b11 && coinInserted) nextState = wstate4;
					else nextState = wstate3;
			state4: //if (CoinValue == 2'b01 && coinInserted) nextState = wstate1;
					//else if (CoinValue == 2'b10 && coinInserted) nextState = wstate3;
					//else if (CoinValue == 2'b11 && coinInserted) nextState = wstate5;
					nextState = state0;
			state5: //if (CoinValue == 2'b01 && coinInserted) nextState = wstate2;
					//else if (CoinValue == 2'b10 && coinInserted) nextState = wstate4;
					//else if (CoinValue == 2'b11 && coinInserted) nextState = wstate6;
					nextState = state1;
			state6: //if (CoinValue == 2'b01 && coinInserted) nextState = wstate3;
					//else if (CoinValue == 2'b10 && coinInserted) nextState = wstate5;
					//else if (CoinValue == 2'b11 && coinInserted) nextState = wstate7;
					nextState = state2;
			state7: //if (CoinValue == 2'b01 && coinInserted) nextState = wstate4;
					//else if (CoinValue == 2'b10 && coinInserted) nextState = wstate6;
					//else if (CoinValue == 2'b11 && coinInserted) nextState = wstate4;
					nextState = state3;
			wstate0: if (!coinInserted) nextState = state0;
				 else nextState = wstate0;
			wstate1: if (!coinInserted) nextState = state1;
				 else nextState = wstate1;
			wstate2: if (!coinInserted) nextState = state2;
				 else nextState = wstate2;
			wstate3: if (!coinInserted) nextState = state3;
				 else nextState = wstate3;
			wstate4: if (!coinInserted) nextState = state4;
				 else nextState = wstate4;
			wstate5: if (!coinInserted) nextState = state5;
				 else nextState = wstate5;
			wstate6: if (!coinInserted) nextState = state6;
				 else nextState = wstate6;
			wstate7: if (!coinInserted) nextState = state7;
				 else nextState = wstate7;

		endcase
	end

	// Your output logic goes here: combinational logic that   
	// drives drop and credit based upon current state (q0, etc).   
	always_comb 
	begin
		//$monitor("credit: %b, drop; %b", credit, drop);
		if (state>=4'b1100) 
			drop = !coinInserted;
		else
			drop = 0;
	end 

endmodule: myCoinFSM 


