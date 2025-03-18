module transmitter
  import definitions_pkg::*;
(
    input logic clk,
    input logic enabled,
    input logic start,
    input logic [7:0] data,
    output logic busy,
    output logic done,
    output logic out
);

  localparam int AccMax = CLOCK_RATE / (2 * BAUD_RATE);
  localparam int AccWidth = $clog2(AccMax);

  logic [7:0] buffer = 8'b0;
  logic [2:0] offset = 3'b0;
  logic [AccWidth-1:0] counter = 0;
  logic signal = 1'b0;

  always_ff @(posedge clk) begin
    if (counter == TxAccMax[TxAccWidth-1:0]) begin
      counter <= 0;
      signal <= ~signal;
    end else begin
      counter <= counter + 1'b1;
    end
  end

  always_ff @(posedge signal) begin
    if (!enabled) begin
      // Reset the transmitter
      busy <= 1'b0;
      done <= 1'b0;
      out <= 1'b1;
      offset <= 3'b0;
    end else begin
      if (!busy && !done && start) begin
        // Start transmission
        buffer <= in;
        busy <= 1'b1;
        done <= 1'b0;
        out <= 1'b0;  // send the start bit (low)
        offset <= 3'b0;
      end else if (busy && !done) begin
        // Transmitting data bits
        buffer <= {1'b0, buffer[7:1]};
        out <= buffer[0];
        offset <= offset + 3'b001;
        if (&offset) begin
          // Finished transmitting data bits
          done <= 1'b1;
          out  <= 1'b1;  // send the stop bit (high)
        end
      end else if (done) begin
        // Transmission complete
        if (start) begin
          // Start the next transmission
          buffer <= in;
          done <= 1'b0;
          out <= 1'b0;
          offset <= 3'b0;
        end else begin
          // Reset state
          busy <= 1'b0;
          done <= 1'b0;
          out <= 1'b1;
          offset <= 3'b0;
        end
      end
    end
  end

endmodule
