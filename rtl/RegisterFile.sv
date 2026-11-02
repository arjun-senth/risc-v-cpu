`timescale 1ns / 1ps

module RegisterFile
  import cpu_pkg::*;
(
    input logic clk,

    input logic [4:0] rs1_addr,
    input logic [4:0] rs2_addr,

    output word_t rs1_data,
    output word_t rs2_data,

    input logic        we,
    input logic  [4:0] rd_addr,
    input word_t       rd_data
);
  word_t regs[32];

  always_ff @(posedge clk) begin
    if (we && rd_addr != 5'd0) begin
      regs[rd_addr] <= rd_data;
    end
  end

  assign rs1_data = (rs1_addr == 5'd0) ? '0 : regs[rs1_addr];
  assign rs2_data = (rs2_addr == 5'd0) ? '0 : regs[rs2_addr];
endmodule
