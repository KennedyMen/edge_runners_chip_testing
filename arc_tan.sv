module arc_tan(
  input   logic   signed [10:0]  Gx, Gy,
  output  logic          [1:0]   angle // 0: 0, 1:45, 2:90, 3:135
);

  logic [10:0] Gx_u, Gy_u;

  always_comb begin
    angle = 2'b00; 
    Gx_u  = Gx[10] ? (~Gx + 1'b1) : Gx;
    Gy_u  = Gy[10] ? (~Gy + 1'b1) : Gy;

    if (Gx == 0 && Gy == 0) begin
      angle = 2'b00; 
    end
    else if (Gx == 0) begin
      angle = 2'b10; 
    end
    else if (Gy == 0) begin
      angle = 2'b00; 
    end
    else begin
      if ((!Gx[10]) && (!Gy[10])) begin
        angle = (Gy_u > Gx_u) ? 2'b01 : 2'b00;
      end
      else if ((Gx[10]) && (Gy[10])) begin
        angle = (Gy_u > Gx_u) ? 2'b01 : 2'b00;
      end
      else if ((!Gx[10]) && (Gy[10])) begin
        angle = (Gy_u > Gx_u) ? 2'b11 : 2'b00;
      end
      else begin
        angle = (Gy_u > Gx_u) ? 2'b11 : 2'b00;
      end
    end
  end
  
endmodule: arc_tan