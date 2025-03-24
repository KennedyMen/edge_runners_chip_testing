module baud_gen
   import definitions_pkg::*;
   (
    input  logic clk, rstN,
    input  logic [2:0] divisor, // divisor for the baud rate
    output logic tick // tick signal
   );

   logic [10:0] r_reg;
   logic [10:0] r_next;


   always_ff @(posedge clk , negedge rstN) begin
      if (!rstN) begin
         r_reg <= 11'd0;
      end
       else begin
         r_reg <= r_next;
      end
   assign r_next = (r_reg == divisor) ? 1 : r_reg + 1;
   assign tick = r_reg == divisor;
   end 
   endmodule
