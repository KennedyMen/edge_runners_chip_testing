package definitions_pkg;
  parameter IMAGE_WIDTH = 512;

  // The clock rate of the board
  parameter int CLOCK_RATE = 10000000;
  // The clock period of the board
  parameter int CLOCK_PERIOD_NANOS = 1000000000 / CLOCK_RATE;
  // The baud rate of the UART interface
  parameter BAUD_RATE = 625000;
  //Width of the baud rate
  parameter int BAUD_RATE_WIDTH = $clog2(BAUD_RATE);
  // The oversample rate of the UART interface
  parameter  OVERSAMPLE_RATE = 16;
  // The number of clock cycles per baud rate tick
  parameter DIVISOR = CLOCK_RATE / (BAUD_RATE * OVERSAMPLE_RATE);
  // The oversample rate runs the UART receiver faster than baud for stability
  // The hold time is how many oversampled baud ticks it takes before the
  // received UART signal is considered stable.
  parameter int HOLD_TIME = 7;

  const logic [7:0] gaussian_kernel_3 [0:8] =  '{
    8'h1, 8'h2, 8'h1, 
    8'h2, 8'h4, 8'h2, 
    8'h1, 8'h2, 8'h1 
  };

  // sobel X kernel
  const logic signed [7:0] sobel_x [0:8] = '{
    8'shff, 8'sh00, 8'sh01,
    8'shfe, 8'sh00, 8'sh02,
    8'shff, 8'sh00, 8'sh01
  };

  // sobel Y kernel
  const logic signed [7:0] sobel_y [0:8] = '{
    8'shff, 8'shfe, 8'shff,
    8'sh00, 8'sh00, 8'sh00,
    8'sh01, 8'sh02, 8'sh01
  };

endpackage: definitions_pkg
