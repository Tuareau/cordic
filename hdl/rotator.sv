`timescale 1ns / 1ps

module rotator # (
    DATA_WIDTH = 12,
    ANGLE_WIDTH = 16,
    ITERATION = 0,
    TAN_ANGLE = 0
)
(
    input clock, 
    input reset,
    
    input [1:0] quarter_in,
    
    input signed [DATA_WIDTH:0] x_in,
    input signed [DATA_WIDTH:0] y_in,
    input signed [ANGLE_WIDTH:0] z_in,
    
    output [1:0] quarter_out,
    
    output signed [DATA_WIDTH:0] x_out,
    output signed [DATA_WIDTH:0] y_out,
    output signed [ANGLE_WIDTH:0] z_out
);
    
    // parameter signed [ANGLE_WIDTH:0] tan_of_angle = '0;

    function signed [DATA_WIDTH:0] shift_register(
        input signed [DATA_WIDTH:0] register, 
        input integer n
    );
        integer i;
        begin
            shift_register = register;
            for (i = 0; i < n; i++) begin
                shift_register = {register[DATA_WIDTH], shift_register[DATA_WIDTH:1]};
            end
        end
    endfunction

    logic signed [DATA_WIDTH:0] Xd, Yd;
    assign Xd = shift_register(x_in, ITERATION);
    assign Yd = shift_register(y_in, ITERATION);   
    
    logic signed [DATA_WIDTH:0] X, Y; 
    logic signed [ANGLE_WIDTH:0] Z; 
        
    always_ff @(posedge clock) begin
        if (z_in < 0) begin
            X <= x_in + Yd;
            Y <= y_in - Xd;
            Z <= z_in + TAN_ANGLE;
        end
        else begin
            X <= x_in - Yd;
            Y <= y_in + Xd;
            Z <= z_in - TAN_ANGLE;
        end   
    end    
        
    assign x_out = X;
    assign y_out = Y;
    assign z_out = Z;    
    assign quarter_out = quarter_in;
    
endmodule

