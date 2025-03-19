module edge_track_hysteresis
    import definitions_pkg::*;
(
    input logic [17:0] strength_value,   // 3x3 grid: 9 pixels, 2 bits each
    input logic strength_valid,
    output logic [7:0] image_out,
    output logic image_out_valid
);  

    assign curr_value = strength_value[9:8];

    always_comb begin 
        image_out = 8'h00;               // Default output: black
        if (curr_value == 2'b01) begin   // Strong edge
            image_out = 8'hff;           // White
        end
        else if (curr_value == 2'b00) begin // No edge
            image_out = 8'h00;           // Black (already default)
        end
        else begin                       // Weak edge (2'b10)
            image_out = 8'h00;           // Default to black unless a strong neighbor is found
            for (int i = 0; i < 9; i++) begin
                if (strength_value[i*2 +: 2] == 2'b01) begin
                    image_out = 8'hff;   // White if any neighbor is strong
                end
            end
        end
    end

    assign image_out_valid = strength_valid; // Pass-through valid signal
endmodule
