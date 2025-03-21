module tb_uart_Split;
    import definitions_pkg::*;

    // Signals
    logic clk;
    logic reset;
    logic rxEnabled;
    logic rx;
    logic [7:0] out;
    logic full;
    logic [7:0] in;
    logic wr_uart;
    logic tx_full;
    logic tx;
    logic txBusy;
    logic txErr;
    logic rx_empty;
    logic rxBusy;
    logic rxErr;

    // Instantiate the UART module
    uart_MENSAH uut (
        .clk(clk),
        .reset(reset),
        .rxEnabled(rxEnabled),
        .rx(rx),
        .rx_empty(rx_empty),
        .rxBusy(rxBusy),
        .rxErr(rxErr),
        .out(out),
        .full(full),
        .in(in),
        .wr_uart(wr_uart),
        .tx_full(tx_full),
        .tx(tx),
        .txBusy(txBusy),
        .txErr(txErr)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #50 clk = ~clk; // 100MHz clock
    end

    // Test procedure
    initial begin
        // Open file for writing
        int file;
        file = $fopen("Testing/Uart_Binary.txt", "w");

        // Initialize signals
        reset = 1;
        rxEnabled = 0;
        rx = 1; // Idle state for UART line
        in = 8'h00;
        wr_uart = 0;

        // Release reset
        #(CLOCK_RATE * 10);
        reset = 0;

        // Enable the receiver
        rxEnabled = 1;

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
        wait(rx_empty == 0);

        // Write the received data to the file
        for (int i = 0; i < 8; i++) begin
            $fwrite(file, "%h\n", out);
            #(CLOCK_RATE * 10);
        end

        // Close the file
        $fclose(file);

        // End simulation
        $finish;
    end

    // Task to send a byte of data
    task send_byte(input [7:0] bytei);
        integer i;
        // Start bit
        rx = 0;
        #(CLOCK_RATE * OVERSAMPLE_RATE);
        // Data bits
        for (i = 0; i < 8; i = i + 1) begin
            rx = bytei[i];
            #(CLOCK_RATE * OVERSAMPLE_RATE);
        end
        // Stop bit
        rx = 1;
        #(CLOCK_RATE * OVERSAMPLE_RATE);
    endtask

endmodule
   