module Non_Max_Suppresion (
    input  logic [98:0] Gradiant_Magnitude_Data,
    input  logic [17:0] Direction_Data,
    input  logic        Gradiant_Magnitude_in_valid,
    input  logic        Direction_Data_in_valid,
    output logic [10:0] NMS_pixel,
    output logic        NMS_Pixels_out_valid,
    output logic [ 1:0] NMS_Direction_Data
);

  logic [10:0] Gradiant_Magnitude_center;
  logic [ 1:0] Direction_Data_center;
  assign NMS_Direction_Data = Direction_Data_center;
  assign NMS_pixel = Gradiant_Magnitude_center;
  assign NMS_Pixels_out_valid = Direction_Data_in_valid & Gradiant_Magnitude_in_valid;
  always_comb begin
    Direction_Data_center = Direction_Data[9:8];
    Gradiant_Magnitude_center = Gradiant_Magnitude_Data[54:44];
    case (Direction_Data_center)
      2'b00: begin
        if (Gradiant_Magnitude_center<= Gradiant_Magnitude_Data[43:33] ||
          Gradiant_Magnitude_center<= Gradiant_Magnitude_Data[65:55]) begin
          Gradiant_Magnitude_center = 11'b0;
        end
      end
      2'b01: begin
        if (Gradiant_Magnitude_center<= Gradiant_Magnitude_Data[98:88] ||
          Gradiant_Magnitude_center<= Gradiant_Magnitude_Data[10:0]) begin
          Gradiant_Magnitude_center = 11'b0;

        end
      end
      2'b10: begin
        if (Gradiant_Magnitude_center<= Gradiant_Magnitude_Data[32:22] ||
          Gradiant_Magnitude_center<= Gradiant_Magnitude_Data[76:66]) begin
          Gradiant_Magnitude_center = 11'b0;

        end
      end
      2'b11: begin
        if (Gradiant_Magnitude_center<= Gradiant_Magnitude_Data[21:11] ||
          Gradiant_Magnitude_center<= Gradiant_Magnitude_Data[87:77]) begin
          Gradiant_Magnitude_center = 11'b0;

        end
      end
      default: begin
        Gradiant_Magnitude_center = Gradiant_Magnitude_Data[54:44];
      end
    endcase
  end


endmodule
