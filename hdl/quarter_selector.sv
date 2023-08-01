`timescale 1ns / 1ps

module quarter_selector # (
    DATA_WIDTH = 12
)
(
    input clock, 
    input reset,
    
    input [1:0] quarter,
    
    input signed [DATA_WIDTH:0] x_in,
    input signed [DATA_WIDTH:0] y_in,
    
    output signed [DATA_WIDTH:0] x_out,
    output signed [DATA_WIDTH:0] y_out

);
    
logic [DATA_WIDTH:0] x_up, x_down;
logic [DATA_WIDTH:0] y_up, y_down;
    
assign x_up = x_in + 13'h800;
assign x_down = 13'h800 - x_in;

assign y_up = y_in + 13'h800;
assign y_down = 13'h800 - y_in;

logic [DATA_WIDTH:0] X, Y;

always_ff @(posedge clock) begin
    if (reset) begin
        X <= '0;
        Y <= '0;    
    end
    else begin
        case (quarter)
            2'b00: begin
                X <= x_up;
                Y <= y_up; 
            end
            2'b01: begin
                X <= x_down;
                Y <= y_up;                        
            end
            2'b10: begin
                X <= x_down;
                Y <= y_down;                                    
            end
            2'b11: begin
                X <= x_up;
                Y <= y_down;                                               
            end
        endcase    
    end
end
    
assign x_out = X;
assign y_out = Y;
    
endmodule

