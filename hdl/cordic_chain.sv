`timescale 1ns / 1ps

module cordic_chain #(
    DATA_WIDTH = 12,
    ANGLE_WIDTH = 16,
    ITERATIONS = 16
)
(
    input clock,
    input reset,
    
    input [1:0] quarter_in,
    
    input signed [DATA_WIDTH:0] x_in,
    input signed [DATA_WIDTH:0] y_in,
    input signed [DATA_WIDTH:0] angle_in,
    
    output signed [DATA_WIDTH:0] x_out,
    output signed [DATA_WIDTH:0] y_out, 
         
    output [1:0] quarter_out 
 );

    logic [1:0] quarters [ITERATIONS:0];
    logic signed [DATA_WIDTH:0] xs [ITERATIONS:0];
    logic signed [DATA_WIDTH:0] ys [ITERATIONS:0];
    logic signed [ANGLE_WIDTH:0] zs [ITERATIONS:0];   
    
    assign quarters[0] = quarter_in;
    assign xs[0] = x_in;
    assign ys[0] = y_in;
    assign zs[0] = {1'b0, angle_in[DATA_WIDTH-1:0], 4'b0000};

    function [ANGLE_WIDTH:0] tan_angle; 
        input [3:0] iteration;
        begin
            case (iteration)
            4'b0000: tan_angle = 17'd25736; // 1/1
            4'b0001: tan_angle = 17'd15192; // 1/2
            4'b0010: tan_angle = 17'd8028; // 1/4
            4'b0011: tan_angle = 17'd4074; // 1/8
            4'b0100: tan_angle = 17'd2045; // 1/16
            4'b0101: tan_angle = 17'd1024; // 1/32
            4'b0110: tan_angle = 17'd512; // 1/64
            4'b0111: tan_angle = 17'd256; // 1/128
            4'b1000: tan_angle = 17'd128; // 1/256
            4'b1001: tan_angle = 17'd64; // 1/512
            4'b1010: tan_angle = 17'd32; // 1/1024
            4'b1011: tan_angle = 17'd16; // 1/2048
            4'b1100: tan_angle = 17'd8; // 1/4096
            4'b1101: tan_angle = 17'd4; // 1/8192
            4'b1110: tan_angle = 17'd2; // 1/16384
            4'b1111: tan_angle = 17'd1; // 1/32768
            endcase
        end
    endfunction

    genvar i;
    generate 
    for (i = 0; i < ITERATIONS; i++) begin
        rotator # (
            .DATA_WIDTH(DATA_WIDTH),
            .ANGLE_WIDTH(ANGLE_WIDTH),
            .ITERATION(i),
            .TAN_ANGLE(tan_angle(i))
        ) rotator_dut (
            .clock(clock),
            .reset(reset),
            
            .quarter_in(quarters[i]),
            .x_in(xs[i]),
            .y_in(ys[i]),
            .z_in(zs[i]),
            
            .quarter_out(quarters[i+1]),
            .x_out(xs[i+1]),
            .y_out(ys[i+1]),
            .z_out(zs[i+1])        
        );   
    end
    endgenerate
    
    assign x_out = xs[ITERATIONS];
    assign y_out = ys[ITERATIONS];
    assign quarter_out = quarters[ITERATIONS];

endmodule

