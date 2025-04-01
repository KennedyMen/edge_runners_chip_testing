module gaussian_filter
// this import will only be commented out for testing purposes
import definitions_pkg::*;
(
    input  logic        clk,
    input  logic        rstN,
    input  logic [71:0] gaussian_data_in,
    input  logic        gaussian_data_in_valid,
    output logic [ 7:0] gaussian_pixel_out,
    output logic        gaussian_pixel_out_valid
    //---------------TESTING LOGIC SECTION ONLY COMMENTED OUT FOR TESTING-----
    // input   logic         kernel_select
);

  //----------------TESTING LOGIC COMMENTED OUT FOR ACTUAL DESIGN-----------
  // logic [7:0] gaussian_kernel_3 [0:8];
  // always_comb begin
  //   if (kernel_select == 0) begin
  //     gaussian_kernel_3  =  '{
  //       8'h1, 8'h2, 8'h1,
  //       8'h2, 8'h4, 8'h2,
  //       8'h1, 8'h2, 8'h1
  //       };
  //
  //     end else begin
  //       gaussian_kernel_3 = '{
  //         8'h0, 8'h0, 8'h0,
  //         8'h0, 9'h10, 8'h0,
  //         8'h0, 8'h0, 8'h0
  //         };
  //
  //       end
  // end
  logic [15:0] mult_data[8:0];
  logic [15:0] sum_data, sum_data_next;
  logic mult_data_valid, sum_data_valid;

  // sequential logic for multiplication data, sum data, and output data
  always @(posedge clk) begin
    if (!rstN) begin
      mult_data <= '{default: 16'b0};
      sum_data <= '0;
      gaussian_pixel_out <= '0;
    end else begin
      for (int i = 0; i < 9; i++) begin
        mult_data[i] <= gaussian_kernel_3[i] * gaussian_data_in[i*8+:8];
      end
      sum_data <= sum_data_next;
      gaussian_pixel_out <= (sum_data >> 4);
    end
  end

  // sequential logic for data valid signals with each pipeline stage
  always @(posedge clk) begin
    if (!rstN) begin
      mult_data_valid <= '0;
      sum_data_valid <= '0;
      gaussian_pixel_out_valid <= '0;
    end else begin
      mult_data_valid <= gaussian_data_in_valid;
      sum_data_valid <= mult_data_valid;
      gaussian_pixel_out_valid <= sum_data_valid;
    end
  end

  // combinational logic for sum calculation from multiply accumulate
  always_comb begin
    sum_data_next = '0;
    for (int i = 0; i < 9; i++) begin
      sum_data_next = sum_data_next + mult_data[i];
    end
  end

endmodule : gaussian_filter
