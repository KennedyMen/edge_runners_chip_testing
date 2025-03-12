module Non_Max_Suppresion(
    input   logic   signed [10:0]  Gradiant_Magnitude_Pixel,
    input   logic   signed [1:0]   Direction_Pixel,
    output  logic   signed [10:0]  processed_pixels [0:11]
  );
  
  logic signed [10:0] gradient_array [0:11];
  logic signed [1:0] direction_array [0:11];

  always_comb begin
    for (int i = 0; i < 12; i++) begin
      gradient_array[i] = Gradiant_Magnitude_Pixel; // import 12 pixels 
      direction_array[i] = Direction_Pixel; // import 12 pixels
    end

    case (Direction_Pixel[4])
      2'b00: begin
        if (gradient_array[4] >= gradient_array[3] && gradient_array[4] >= gradient_array[5]) begin
          gradient_array[3] = 0; 
          gradient_array[5] = 0; 
        end 
      end
      2'b01: begin
        if (gradient_array[4] >= gradient_array[7] && gradient_array[4] >= gradient_array[1]) begin
          gradient_array[2] = 0; 
          gradient_array[10] = 0; 
        end
      end
      2'b10: begin
        if (gradient_array[4] >= gradient_array[2] && gradient_array[4] >= gradient_array[6]) begin
          gradient_array[2] = 0; 
          gradient_array[6] = 0; 
        end 
      end
      2'b11: begin
        if (gradient_array[4] >= gradient_array[7] && gradient_array[4] >= gradient_array[0]) begin
          gradient_array[8] = 0; 
          gradient_array[0] = 0; 
        end
      end
    endcase

    for (int i = 0; i < 12; i++) begin
      processed_pixels[i] = gradient_array[i];
    end
  end
endmodule