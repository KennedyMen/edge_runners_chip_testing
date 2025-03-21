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
    
    // Test data
    logic [7:0] test_data [8] = '{8'h41, 8'h42, 8'h43, 8'h44, 8'h45, 8'h46, 8'h47, 8'h48}; // ASCII for "ABCDEFGH"
    logic [7:0] received_data [8];
    integer file_handle;
    
    // UART parameters
    parameter CLKS_PER_BIT = 16; // Assuming 16 clock cycles per bit
    parameter BIT_PERIOD = CLKS_PER_BIT; // Clock periods for one bit
    
    // Instantiate the UART module
    uart_Split uut (
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
    always begin
        #5 clk = ~clk; // 100MHz clock (10ns period)
    end
    
    // Task to send one byte through UART TX
    task send_byte(input logic [7:0] data);
        begin
            // Wait until TX is not busy
            wait(!tx_full);
            
            // Send data
            @(posedge clk);
            in = data;
            wr_uart = 1'b1;
            @(posedge clk);
            wr_uart = 1'b0;
            
            // Wait for transmission to complete
            wait(!txBusy);
            #(BIT_PERIOD * 2); // Additional wait time between bytes
        end
    endtask
    
    // Task to receive one byte from UART RX
    task receive_byte(output logic [7:0] data);
        begin
            // Wait for data to be available
            wait(!rx_empty);
            
            // Read data
            @(posedge clk);
            data = out;
            
            // Wait a bit before next byte
            #(BIT_PERIOD * 2);
        end
    endtask
    
    // Task to simulate UART RX input (serial data in)
    task uart_rx_send_byte(input logic [7:0] data);
        integer i;
        begin
            // Start bit (low)
            rx = 1'b0;
            #(BIT_PERIOD * CLKS_PER_BIT);
            
            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_PERIOD * CLKS_PER_BIT);
            end
            
            // Stop bit (high)
            rx = 1'b1;
            #(BIT_PERIOD * CLKS_PER_BIT);
            
            // Additional wait time
            #(BIT_PERIOD * 2);
        end
    endtask
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        rxEnabled = 0;
        rx = 1;  // Idle state is high
        wr_uart = 0;
        in = 8'h00;
        
        // Open file for writing
        file_handle = $fopen("uart/Testing/Uart_Binary.txt", "wb");
        if (file_handle == 0) begin
            $display("Error: Could not open file for writing");
            $finish;
        end
        
        // Reset sequence
        #20 reset = 0;
        #20 reset = 1;
        #20;
        
        // Enable receiver
        rxEnabled = 1;
        #20;
        
        // Simulate receiving 8 bytes (as if from an external UART)
        $display("Sending 8 bytes to UART RX...");
        for (int i = 0; i < 8; i++) begin
            uart_rx_send_byte(test_data[i]);
            #(BIT_PERIOD * 5); // Wait between bytes
        end
        
        // Read the received data
        $display("Reading received data...");
        for (int i = 0; i < 8; i++) begin
            receive_byte(received_data[i]);
            // Write to file
            $fwrite(file_handle, "%c", received_data[i]);
            $display("Received byte %0d: 0x%h (%c)", i, received_data[i], received_data[i]);
        end
        
        // Write the same data back out through the TX
        $display("Sending 8 bytes through UART TX...");
        for (int i = 0; i < 8; i++) begin
            send_byte(received_data[i]);
            #(BIT_PERIOD * 5); // Wait between bytes
        end
        
        // Close file
        $fclose(file_handle);
        
        $display("Test completed. Data written to uart/Testing/Uart_Binary.txt");
        #1000;
        $finish;
        forever @(txBusy, txErr, rxErr) begin
            if (txBusy)
                $display("TX busy, transmitting...");
            if (txErr)
                $display("TX Error detected!");
            if (rxErr)
                $display("RX Error detected!");
        end
    end
    
    // Optional: Monitor the TX line to verify data


endmodule
