module FIFO #(parameter WIDTH = 8, DEPTH = 16) (
    input logic clk,
    input logic reset,
    input logic wr_en,
    input logic rd_en,
    input logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out,
    output logic full,
    output logic empty
);

    logic [WIDTH-1:0] mem [0:DEPTH-1];
    logic [$clog2(DEPTH):0] rd_ptr, wr_ptr, count;
    logic [WIDTH-1:0] data_out_reg;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            rd_ptr <= 0;
            wr_ptr <= 0;
            count <= 0;
            mem <= '{default: 0};
            data_out_reg <= 0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                data_out_reg <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
        end
    end
    assign data_out = data_out_reg;
    assign full = (count == DEPTH);
    assign empty = (count == 0);

endmodule
