module baud_gen
   (
    input  logic clk, reset,
    input  logic [13:0] divisor, // divisor for the baud rate
    output logic tick // tick signal
   );

   logic [10:0] r_reg;
   logic [10:0] r_next;


   always_ff @(posedge clk or posedge reset) begin
      if (reset) begin
         r_reg <= 11'd0;
      end
       else begin
         r_reg <= r_next;
      end
   assign r_next = (r_reg == divisor) ? 11'd0 : r_reg + 11'd1;
   assign tick = r_reg == divisor;
   end 
endmodule