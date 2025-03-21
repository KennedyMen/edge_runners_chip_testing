module uart_MENSAH
    import definitions_pkg::*;
    (
        input logic clk,reset,
    
        // rx interface
        input logic rxEnabled,
        input logic rx,
        output logic rx_empty,
        output logic rxBusy,
        output logic rxErr,
        output logic [7:0] out,
        output logic full,
        // tx interface
        input logic [7:0] in,
        input logic wr_uart,
        output logic tx_full,
        output logic tx,
        // information
        output logic txBusy,
        output logic txErr
        
    );
    // intermediary
    logic [7:0] din;
    logic tx_done_tick;
    logic tx_start;

    logic [7:0] dout;
    logic rx_done_tick;


    logic s_tick;

    Kennedy_Receiver receiver (
        .clk(clk),
        .rstN(reset),
        .rx_enabled(rxEnabled),
        .in(rx),
        .s_tick(s_tick),
        .busy(rxBusy),
        .done(rx_done_tick),
        .err(rxErr),
        .out(dout)
    );
    Kennedy_Transmitter transmitter (
        .clk(clk),
        .rstN(reset),
        .tx_enabled(!tx_start),
        .tx_in(din),
        .s_tick(s_tick),
        .busy(txBusy),
        .done(tx_done_tick),
        .err(txErr),
        .tx_out(tx)
    );
    FIFO #(.WIDTH(8), .DEPTH(16)) fifo_tx (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_uart),
        .rd_en(tx_done_tick),
        .data_in(in),
        .data_out(din),
        .full(tx_start),
        .empty(tx_full)
    );
    FIFO #(.WIDTH(8), .DEPTH(16)) fifo_rx (
        .clk(clk),
        .reset(reset),
        .wr_en(rx_done_tick),
        .rd_en(rx_empty),
        .data_in(dout),
        .data_out(out),
        .full(full),
        .empty(rx_empty)
    );
    baud_gen baud_generator (
        .clk(clk),
        .reset(reset),
        .baud_rate(BAUD_RATE[BAUD_RATE_WIDTH-1:0]),
        .tick(s_tick)
    );
endmodule