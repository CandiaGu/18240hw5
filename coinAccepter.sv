`default_nettype none
/*
 * Copyright (C) 2014 Carnegie Mellon University
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including without
 * limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * John Greth (jgreth@cmu.edu)
 *
 */
 
module coinAccepter (
    input  logic  CLOCK_50,  // pin Y2
    input  logic  reset,
    input  logic  UART_RXD,  // pin G12
    input  logic  UART_RTS,  // pin J13
    output logic  UART_TXD,  // pin G9
    output logic  UART_CTS,  // pin G14
    output logic  circle, triangle, pentagon,
    input  logic  manualMode, manualClockL,
    input  logic  manualCircleL, manualTriangleL, manualPentagonL,
    output logic  clock);
 
    parameter count_width = 26;
    wire clk_edge; 
    reg [count_width-1:0] count;
    wire [count_width-1:0] count_n, count_inc;
    reg [2:0] bits, coin, random, KEY, last_key;
    wire [2:0] bits_n, bits_rx, bits_key, coin_n, coin_k, coin_c, in_both;
    reg last_rxd, last_manualCLK;
    reg [15:0] CLK_COUNT, rxd_count;
    wire is_input, rxd_edge;
    
    // Debounced clock
    reg manualCLK, debounced_rxd;
    
    // IO
    assign {pentagon, triangle, circle} = coin;
    
    // positive edge
    assign rxd_edge = debounced_rxd & ~last_rxd;
    assign clk_edge = manualCLK & ~last_manualCLK;
    
    // choose clock
    assign clock = (manualMode & manualCLK) | (~manualMode & CLOCK_50);
    
    // next coin
    assign coin_n = manualMode ? coin_k : coin_c;
    
    assign coin_c = count[count_width-1] ? ((count == {1'b1, {(count_width-1){1'b0}}}) ? bits : coin) : 0;
    assign coin_k = (count_n == 0) ? 0 : (count_n == 1) ? KEY : coin;
    
    // keeps track of the number of pulses, resets when counter is really high.
    assign bits_n = count[count_width-1] ? 0 : rxd_edge ? {bits, (bits == 0)} : bits;
    
    // Counter starts when it sees an input.
    assign count_inc = (manualMode & (count >= random)) ? 0 : (count + 1);
    assign is_input = manualMode ? (KEY != 0) : (bits != 0);
    
    assign count_n = (count == 0) ? is_input : count_inc;
    
    // Latch the key at any time
    always_ff @(posedge CLOCK_50) begin
        KEY <= (reset | clk_edge) ? 0 : (KEY | ~{manualPentagonL, manualTriangleL, manualCircleL});
        last_manualCLK <= manualCLK;
    end
    
    // update the state machine
    always_ff @(posedge clock) begin
        if (reset) begin
            coin <= 0;
            last_rxd <= 0;
            count <= 0;
            bits <= 0;
            random <= 5;
            last_key <= 0;
        end else begin
            last_key <= KEY;
            coin <= coin_n;
            last_rxd <= debounced_rxd;
            count <= count_n;
            bits <= bits_n;
            
            random <= (random == 2) ? 5 : (random - 1);
        end
    end
    
    // Debounce the clock and rxd
    always_ff @(posedge CLOCK_50) begin
        if (manualCLK ^ ~manualClockL) begin
            // output clock changes if input clock has been different for 0xFFFF cycles in a row.
            manualCLK <= manualCLK ^ (CLK_COUNT == 16'hFFFF);
            CLK_COUNT <= CLK_COUNT + 1;
        end else begin
            manualCLK <= manualCLK;
            CLK_COUNT <= 0;
        end
        if (debounced_rxd ^ UART_RXD) begin
            // output clock changes if input clock has been different for 0xFFFF cycles in a row.
            debounced_rxd <= debounced_rxd ^ (rxd_count == 16'hFFFF);
            rxd_count <= rxd_count + 1;
        end else begin
            debounced_rxd <= debounced_rxd;
            rxd_count <= 0;
        end
    end
 
endmodule: coinAccepter
