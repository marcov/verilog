/**
* Linear feedback shift register.
* 
* An LFSR is probably the simplest pseudo-random number generator.
* 
* When correctly configured with a maximal length polynomial, it
* will generate a series of numbers with width "n" bits and 
* with a period (2^n)-1
* (-1 because 0 value in an invalid value, as it would set the 
* generator in a all-zeroes state).
*
* I used the LFSR in SW when I needed a _very_ simple pseudo 
* number generator, that would not require MULT or DIV
* operations. To confirm my understanding of how it works,
* I thought about implementing it in RTL that is BTW 
* very simple.
*
*/

module lfsr(
    input   in_clk,
    input   in_n_rst,
    input   [7:0] taps,
    input   [7:0] reset_value,
    output  reg [7:0] computed_value);

    
    always @ (posedge in_clk, negedge in_n_rst)
    begin
        if (!in_n_rst)
        begin
            computed_value <= reset_value;
        end
        else
        begin
            computed_value <= computed_value >> 1;
            computed_value[7] <= computed_value[0] ^
                                 ((taps[6]) ? computed_value[1] : 0) ^
                                 ((taps[5]) ? computed_value[2] : 0) ^
                                 ((taps[4]) ? computed_value[3] : 0) ^
                                 ((taps[3]) ? computed_value[4] : 0) ^
                                 ((taps[2]) ? computed_value[5] : 0) ^
                                 ((taps[1]) ? computed_value[6] : 0) ^
                                 ((taps[0]) ? computed_value[7] : 0);
        end
    end
endmodule 


module lfsr_testbench;
    reg clk;
    reg n_rst;
    reg [7:0] test_taps;
    reg [7:0] test_reset_value;
    wire [7:0] test_computed_value;
    integer posedgectr;

    lfsr lfsr_iut(.in_clk(clk),
                  .in_n_rst(n_rst),
                  .taps(test_taps),
                  .reset_value(test_reset_value),
                  .computed_value(test_computed_value));
    initial
    begin
        #0 
        $monitor("LFSR (clkcycle=%d): %d", posedgectr, test_computed_value);
        $dumpfile("test.lxt");
	    $dumpvars(0, lfsr_testbench);

        n_rst  = 1;
        clk    = 0;
        posedgectr= 0;

        #10
        test_reset_value = 8'hAA;
        test_taps = 8'hB8;
        n_rst = 0;

        #10
        n_rst = 1;

        #512
        $finish;
    end

    always #1 begin
        clk = !clk;
        if (clk) posedgectr = posedgectr + 1;
    end
endmodule
