module Transmitter_Mensah
  import definitions_pkg::*;
(
    input logic clk, rstN,  // rx data sampling rate
    input logic tx_enabled,
    input logic [7:0] tx_in,  // tx line
    input logic s_tick,     
    output logic busy,  // transaction is in progress
    output logic done,  // end of transaction
    output logic err,  // error while receiving data
    output logic tx_out  // the received data assembled in parallel form
);

typedef enum logic [1:0] {
  IDLE = 2'b00,
  START = 2'b01,
  DATA = 2'b10,
  STOP = 2'b11
} state_t;

state_t state_reg, next_state;
logic [3:0] s_reg, s_next;
logic [2:0] n_reg, n_next;
logic out_reg, out_next;
logic busy_reg, done_reg, err_reg,tx_reg,tx_next;
always_ff @(posedge clk or posedge rstN) begin 
    if (rstN) begin
        state_reg <= IDLE;
        s_reg <= 4'b0;
        n_reg <= 3'b0;
        out_reg <= 8'b0;
        busy <= 1'b0;
        done <= 1'b0;
        err <= 1'b0;
        tx_reg <= 1'b1;
    end 
    else begin
        state_reg <= next_state;
        s_reg <= s_next;
        n_reg <= n_next;
        out_reg <= out_next;
        busy <= busy_reg;
        done <= done_reg;
        err <= err_reg;
        tx_reg <= tx_next;
    end
end 

always_comb begin
    next_state = state_reg;
    s_next = s_reg;
    n_next = n_reg;
    out_next = out_reg;
    busy_reg = 1'b0;
    done_reg = 1'b0;
    err_reg = 1'b0;

    case (state_reg) 
        IDLE: begin
            tx_next = 1'b1; 
            if (tx_enabled) begin
                next_state = START;
                busy_reg = 1'b1;
                s_next = 4'b0;
                out_next = tx_in;
            end
        end 
        START: begin
            tx_next = 1'b0;
            if (s_tick) begin
                if (s_reg == OVERSAMPLE_RATE) begin
                    next_state = DATA;
                    n_next = 3'b0;
                    s_next = 4'b0;
                end
                else begin
                    s_next = s_reg + 1'b1;
                end
            end
        end
        DATA: begin
            if (s_tick) begin
                if (s_reg == OVERSAMPLE_RATE - 1) begin
                    out_next = out_reg >> 1'b1;
                    s_next = 4'b0;
                    if (n_reg == 3'b111) begin
                        next_state = STOP;
                    end
                    else begin
                        n_next = n_reg + 1'b1;
                    end
                end
                else begin
                    s_next = s_reg + 1'b1;
                end
            end
        end
        STOP: begin
            tx_next = 1'b1;
            if (s_tick) begin
                if (s_reg == OVERSAMPLE_RATE - 1) begin
                    next_state = IDLE;
                    done_reg = 1'b1;
                    busy_reg = 1'b0;
                end
                else begin
                    s_next = s_reg + 1'b1;
                end
            end
        end
    endcase
     
end     
assign tx_out = tx_reg;
endmodule