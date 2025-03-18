module receiver
  import definitions_pkg::*;
(
    input logic clk,  // rx data sampling rate
    input logic enabled,
    input logic in,  // rx line
    output logic busy,  // transaction is in progress
    output logic done,  // end of transaction
    output logic err,  // error while receiving data
    output logic [7:0] out  // the received data assembled in parallel form
);
  localparam int AccMax = CLOCK_RATE / (2 * BAUD_RATE * OVERSAMPLE_RATE);
  localparam int AccWidth = $clog2(AccMax);

  logic [HOLD_TIME+1:0] in_buffer = {HOLD_TIME + 2{1'b0}};  // input signal conditioning
  logic [3:0] sample_count = 4'b0;  // count ticks for 16x oversample
  logic [4:0] out_hold_count = 5'b0;  // count ticks before clearing output data
  logic [2:0] bit_index = 3'b0;  // index for 8-bit data
  logic [7:0] out_buffer = 8'b0;  // shift reg for the deserialized data
  logic in_sample;
  logic [HOLD_TIME-1:0] in_buffer_last;
  logic [HOLD_TIME-1:0] in_buffer_now;
  logic [AccWidth-1:0] sync_count = 0;
  logic ticker = 1'b0;

  always @(posedge clk) begin
    if (sync_count == AccMax[AccWidth-1:0]) begin
      sync_count <= 0;
      ticker  <= ~ticker;
    end else begin
      sync_count <= sync_count + 1'b1;
    end
  end

  always_ff @(posedge ticker) begin
    in_buffer <= {in_buffer[HOLD_TIME:0], in};

    in_sample <= in_buffer[HOLD_TIME+1];
    in_buffer_last <= in_buffer[HOLD_TIME+1:2];
    in_buffer_now <= in_buffer[HOLD_TIME:1];

    if (out_hold_count) begin
      out_hold_count <= out_hold_count + 5'b00001;
      if (out_hold_count == 5'b10000) begin  // reached 16 -
        // timed output interval ends
        out_hold_count <= 5'b0;
        done <= 1'b0;
        out <= 8'b0;
      end
    end

    if (enabled) begin
      if (!busy && !done && !err && sample_count == 4'b0) begin
        // Was idle
        if (!in_sample) begin
          if (&in_buffer_last && done && !err) begin
            sample_count <= 4'b0001;
            err <= 1'b0;
          end else begin
            err <= 1'b1;
          end
        end else if (sample_count) begin
          sample_count <= 4'b0;
          out_buffer <= 8'b0;
          err <= 1'b1;
        end
      end else if (busy && sample_count == 4'b1100) begin
        // Was reading the start bit
        sample_count <= 4'b0100;
        busy <= 1'b1;
        err <= 1'b0;
      end else if (busy && sample_count == 4'b1111) begin
        // Was reading center bits
        sample_count <= 4'b0;
        bit_index <= bit_index + 3'b001;
        out_buffer <= {in_sample, out_buffer[7:1]};
        if (&bit_index) begin
          sample_count <= 4'b0;
          busy <= 1'b0;
          done <= 1'b1;
          out <= out_buffer;
        end
      end else if (done && sample_count[3]) begin
        // Was reading a stop bit
        if (!in_sample) begin
          if (sample_count == 4'b1000 && &in_buffer_last) begin
            sample_count <= 4'b0;
            out_hold_count <= 5'b00001;
            done <= 1'b1;
            out <= out_buffer;
          end else if (&sample_count) begin
            sample_count <= 4'b0;
            out_buffer <= 8'b0;
            busy <= 1'b0;
            err <= 1'b1;
          end
        end else if (&in_buffer_now) begin
          sample_count <= 4'b0;
          done <= 1'b1;
          out <= out_buffer;
        end else if (&sample_count) begin
          sample_count <= 4'b0;
          err <= 1'b1;
        end
      end else if (done && sample_count == 4'b1111) begin
        // Was ready
        sample_count <= 4'b0;
        done <= 1'b0;
        out <= 8'b0;
        if (!err && !in_sample) begin
          sample_count <= 4'b0001;
        end else if (err && !in_sample) begin
          sample_count <= 4'b0;
          err <= 1'b0;
        end
      end
    end else begin
      // Reset if not enabled
      sample_count <= 4'b0;
      out_hold_count <= 5'b0;
      out_buffer <= 8'b0;
      busy <= 1'b0;
      done <= 1'b0;
      err <= 1'b0;
      out <= 8'b0;
    end
  end
endmodule

