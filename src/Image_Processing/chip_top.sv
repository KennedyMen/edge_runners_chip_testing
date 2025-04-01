module chip_top
  import definitions_pkg::*;
(
    input  logic clk,
    input  logic rstN,
    input  logic rx,
    output logic tx
    //----------------TESTING SIGNAL COMMENTED OUT FOR ACTUAL DESIGN-----------
    // input  logic kernel_select,
    // input  logic [1:0] fill_select
);

  logic [FIFO_WIDTH-1:0] rx_rd_data;
  logic rx_valid;

  logic [FIFO_WIDTH-1:0] tx_wr_data;
  logic tx_wr;

  uart_top uart (
      .clk(clk),
      .rstN(rstN),
      .rx(rx),
      .tx(tx),
      .rx_rd_data(rx_rd_data),
      .rx_valid(rx_valid),
      .tx_wr_data(tx_wr_data),
      .tx_wr(tx_wr),
      //--------------TESTING SIGNAL COMMENTED OUT FOR DESIGN--------
      .fill_select(fill_select)
  );

  canny_edge_top canny_edge (
      .clk(clk),
      .rstN(rstN),
      .pixel_in(rx_rd_data),
      .pixel_in_valid(rx_valid),
      .pixel_out(tx_wr_data),
      .pixel_out_valid(tx_wr),
      //------------TESTING SIGNAL COMMENTED OUT FOR DESIGN----------
      // .kernel_select(kernel_select)
  );
endmodule : chip_top
