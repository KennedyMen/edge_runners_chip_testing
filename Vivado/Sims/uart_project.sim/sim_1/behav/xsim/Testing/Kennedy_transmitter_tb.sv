module tb_Kennedy_Transmitter;
    import definitions_pkg::*;
    // Signals
    logic clk;
    logic rstN;
    logic tx_enabled;
    logic [7:0] tx_in;
    logic s_tick;
    logic busy;
    logic done;
    logic err;
    logic tx_out;

    // Instantiate the Transmitter module
    Kennedy_Transmitter uut (
        .clk(clk),
        .rstN(rstN),
        .tx_enabled(tx_enabled),
        .tx_in(tx_in),
        .s_tick(s_tick),
        .busy(busy),
        .done(done),
        .err(err),
        .tx_out(tx_out)
    );

    // Instantiate the Baud Rate Generator module
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

    // Test procedure
    initial begin
        // Initialize signals
        rstN = 1;
        tx_enabled = 0;
        tx_in = 8'h00;

        // Apply reset
        rstN = 0;
        #(CLOCK_PERIOD_NANOS * 100);
        rstN = 1;

        // Enable the transmitter and send data
        tx_enabled = 1;
        send_byte(8'hA5); // Example byte 1
        send_byte(8'h5A); // Example byte 2
        send_byte(8'hFF); // Example byte 3
        send_byte(8'h00); // Example byte 4
        send_byte(8'h12); // Example byte 5
        send_byte(8'h34); // Example byte 6
        send_byte(8'h56); // Example byte 7
        send_byte(8'h78); // Example byte 8

        // Wait for the transmitter to finish
        wait(done);

        // Check the transmitted data
        if (tx_out == 1'b1) begin
            $display("Test passed: Transmitted data %h", tx_in);
        end else begin
            $display("Test failed: Transmitted data %h", tx_in);
        end

        // End simulation
        $finish;
    end

    // Task to send a byte of data
    task send_byte(input [7:0] bytei);
        integer i;
        // Load the byte to be transmitted
        tx_in = bytei;
        // Wait for the transmitter to be ready
        wait(!busy);
        // Enable transmission
        tx_enabled = 1;
        // Wait for the transmission to complete
        wait(done);
        // Disable transmission
        tx_enabled = 0;
    endtask

endmodule