`timescale 1ns / 1ps

module cordic_tb();

    bit clock = 0;
    bit reset = 0;
      
    logic signed [12:0] sine;
    logic signed [12:0] cosine;
    
    cordic # (
        .DATA_WIDTH(12)
    ) cordic_dut (
        .clock(clock),
        .reset(reset),
        .sine(sine),
        .cosine(cosine)
    );
    
    always #5 begin
        clock <= ~clock;
    end

endmodule

