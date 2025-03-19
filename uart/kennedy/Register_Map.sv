module chu_uart
    import definitions_pkg::*;
(
 input logic clk,
    input logic reset,
    input logic cd,
    input logic read,
    input logic write,
    input logic [4:0] addr,
    input logic [31:0] data_wr,
    output logic [31:0] data_rd,
    output logic tx, 
    input logic rx,
);

endmodule