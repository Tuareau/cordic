`timescale 1ns / 1ps

module phase_controller # (
    PHASE_WIDTH = 13
) 
(
    input clock, 
    
    output [PHASE_WIDTH-1:0] phase,
    output [1:0] quadrant   
);

localparam frequence_fraction = 8'd56;
localparam frequence_reverse_fraction = 8'd100 - frequence_fraction;
localparam phase_90 = 13'd3216;

localparam base_step = 2'd1;
localparam extended_step = 2'd2;

typedef enum logic [1:0] {
    QUADRANT_I, 
    QUADRANT_II,
    QUADRANT_III,
    QUADRANT_IV
} quadrant_state;

logic [PHASE_WIDTH-1:0] phase_out = '0;

logic inc_en = '0; 
logic counter_reset = '0;

logic [15:0] counter = '0;
always_ff @(posedge clock) begin
    if (counter_reset) begin
        counter <= '0;
    end
    else begin
        if (counter >= 8'd100) begin
            inc_en <= '1;
            counter <= counter - frequence_reverse_fraction;
        end
        else begin
            inc_en <= '0;
            counter <= counter + frequence_fraction;
        end
    end
end

quadrant_state quadrant_out = QUADRANT_I;
logic [15:0] angle_counter = '0;

assign quadrant = quadrant_out;
assign phase = phase_out;

always_ff @(posedge clock) begin
    case (quadrant_out)
        QUADRANT_I: begin
            if (angle_counter >= phase_90) begin
                quadrant_out <= QUADRANT_II;
                angle_counter <= '0;                
            end
            else begin
                if (inc_en) begin
                    phase_out <= phase_out + extended_step;
                    angle_counter <= angle_counter + extended_step;
                end
                else begin
                    phase_out <= phase_out + base_step;
                    angle_counter <= angle_counter + base_step;
                end
            end
        end
        QUADRANT_II: begin
            if (angle_counter >= phase_90) begin
                quadrant_out <= QUADRANT_III;
                angle_counter <= '0;                
            end
            else begin
                if (inc_en) begin
                    phase_out <= phase_out - extended_step;
                    angle_counter <= angle_counter + extended_step;
                end
                else begin
                    phase_out <= phase_out - base_step;
                    angle_counter <= angle_counter + base_step;
                end
            end           
        end
        QUADRANT_III: begin
            if (angle_counter >= phase_90) begin
                quadrant_out <= QUADRANT_IV;
                angle_counter <= '0;                
            end
            else begin
                if (inc_en) begin
                    phase_out <= phase_out + extended_step;
                    angle_counter <= angle_counter + extended_step;
                end
                else begin
                    phase_out <= phase_out + base_step;
                    angle_counter <= angle_counter + base_step;
                end
            end        
        end
        QUADRANT_IV: begin
            if (angle_counter >= phase_90) begin
                quadrant_out <= QUADRANT_I;
                angle_counter <= '0;                
            end
            else begin
                if (inc_en) begin
                    phase_out <= phase_out - extended_step;
                    angle_counter <= angle_counter + extended_step;
                end
                else begin
                    phase_out <= phase_out - base_step;
                    angle_counter <= angle_counter + base_step;
                end
            end                                 
        end
    endcase
end

always_ff @(posedge clock) begin
    if (angle_counter >= phase_90) begin
        counter_reset <= '1;
    end
    else begin
        counter_reset <= '0;
    end
end
    
endmodule

