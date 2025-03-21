module tb_Kennedy_Receiver;
    import definitions_pkg::*;
    // Signals
    logic clk;
    logic rstN;
    logic rx_enabled;
    logic in;
    logic s_tick;
    logic busy;
    logic done;
    logic err;
    logic [7:0] out;

    // Instantiate the Receiver module
    Kennedy_Receiver uut (
        .clk(clk),
        .rstN(rstN),
        .rx_enabled(rx_enabled),
        .in(in),
        .s_tick(s_tick),
        .busy(busy),
        .done(done),
        .out(out)
    );
    baud_gen baud_gen_inst (
        .clk(clk),
        .reset(rstN),
        .divisor(DIVISOR),
        .tick(s_tick)
    );
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD_NANOS / 2) clk = ~clk;
    end

    // Baud rate tick generation


    // Test procedure
    initial begin
        // Initialize signals
        rstN = 1;
        rx_enabled = 0;
        in = 1; // Idle state for UART line

        // Apply reset
        rstN = 0;
        #(CLOCK_PERIOD_NANOS * 100);
        rstN = 1;

        // Enable the receiver
        rx_enabled = 1;

        // Send 8 bytes of data
        send_byte(8'hA5); // Example byte 1
        send_byte(8'h5A); // Example byte 2
        send_byte(8'hFF); // Example byte 3
        send_byte(8'h00); // Example byte 4
        send_byte(8'h12); // Example byte 5
        send_byte(8'h34); // Example byte 6
        send_byte(8'h56); // Example byte 7
        send_byte(8'h78); // Example byte 8

        // Wait for the receiver to finish
        wait(done);

        // Check the received data
        if (out == 8'h78) begin
            $display("Test passed: Received data %h", out);
        end else begin
            $display("Test failed: Received data %h", out);
        end

        // End simulation
        $finish;
    end

    // Task to send a byte of data
    task send_byte(input [7:0] bytei);
        integer i;
        // Start bit
        in = 0;
        #(CLOCK_PERIOD_NANOS * DIVISOR * OVERSAMPLE_RATE);
        // Data bits
        for (i = 0; i < 8; i = i + 1) begin
            in = bytei[i];
            #(CLOCK_PERIOD_NANOS * DIVISOR * OVERSAMPLE_RATE);
        end
        // Stop bit
        in = 1;
        #(CLOCK_PERIOD_NANOS * DIVISOR * OVERSAMPLE_RATE);
    endtask

endmodule