`timescale 1ns / 1ps

module cordic # (
    DATA_WIDTH = 12
)
(
    input clock,
    input reset,    
    output signed [DATA_WIDTH:0] sine,
    output signed [DATA_WIDTH:0] cosine
);

    localparam A = 16'h04DB; // scale coefficient
    
    logic [DATA_WIDTH:0] phase;
    logic [1:0] quarter;
    
    logic signed [DATA_WIDTH:0] x0;
    logic signed [DATA_WIDTH:0] y0;
    assign x0 = A;
    assign y0 = '0;
    
    phase_controller # (
        .PHASE_WIDTH(13)
    ) phase_controller_dut (
        .clock(clock),
        
        .phase(phase),
        .quadrant(quarter)
    );
    
    logic signed [DATA_WIDTH:0] x_out;
    logic signed [DATA_WIDTH:0] y_out;
    logic [1:0] quarter_out;
      
    cordic_chain # (
        .DATA_WIDTH(12),
        .ANGLE_WIDTH(16),
        .ITERATIONS(16)
    ) cordic_chain_dut (
        .clock(clock),
        .reset(reset),
        
        .quarter_in(quarter),
        
        .x_in(x0),
        .y_in(y0),
        .angle_in(phase),        
        
        .x_out(x_out),
        .y_out(y_out),
        .quarter_out(quarter_out)        
    );
    
    quarter_selector # (
        .DATA_WIDTH(12)
    ) quarter_selector_dut (
        .clock(clock),
        .reset(reset),
        
        .quarter(quarter_out),
        
        .x_in(x_out),
        .y_in(y_out),
        
        .x_out(cosine),
        .y_out(sine)
    );

endmodule