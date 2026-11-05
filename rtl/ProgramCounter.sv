`timescale 1ns / 1ps

module ProgramCounter
  import cpu_pkg::*;
#(
  parameter word_t RESET_ADDR = 32'b0
) (
  input  logic  clk,
  input  logic  rst,
  output word_t pc_addr,
  input  word_t pc_next
);
  always_ff @(posedge clk) begin
    if (rst) pc_addr <= RESET_ADDR;
    else pc_addr <= pc_next;
  end
endmodule
