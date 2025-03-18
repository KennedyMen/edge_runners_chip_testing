module uart
  import definitions_pkg::*;
(
    input logic clk,

    // rx interface
    input logic rxEnabled,
    input logic rx,
    output logic rxBusy,
    output logic rxDone,
    output logic rxErr,
    output logic [7:0] out,

    // tx interface
    input logic txEnabled,
    input logic txStart,
    input logic [7:0] in,
    output logic txBusy,
    output logic txDone,
    output logic tx
);

receiver uart_rx (
    .clk(clk),
    .enabled(rxEnabled),
    .in(rx),
    .busy(rxBusy),
    .done(rxDone),
    .err(rxErr),
    .out(out)
);

transmitter uart_tx (
    .clk(clk),
    .enabled(txEnabled),
    .start(txStart),
    .in(in),
    .busy(txBusy),
    .done(txDone),
    .out(tx)
);

endmodule
