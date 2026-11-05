`timescale 1ns / 1ps

module DataMem
  import cpu_pkg::*;
#(
  parameter int DEPTH = 128
) (
  input  logic        clk,
  input  logic        mem_write,
  input  logic        mem_read,
  input  logic  [2:0] funct3,
  input  word_t       addr,
  input  word_t       wdata,
  output word_t       rdata
);

  localparam int IDXW = $clog2(DEPTH);
  logic [31:0] mem[DEPTH];

  logic [IDXW-1:0] idx;
  assign idx = addr[IDXW+1:2];
  logic [1:0] off;
  assign off = addr[1:0];

  logic [ 3:0] be;
  logic [31:0] wshift;

  always_comb begin
    case (funct3[1:0])
      2'b00: begin
        be = 4'b0001 << off;
        wshift = {4{wdata[7:0]}};
      end
      2'b01: begin
        be = 4'b0011 << off;
        wshift = {2{wdata[15:0]}};
      end
      default: begin
        be = 4'b1111;
        wshift = wdata[31:0];
      end
    endcase
  end

  always_ff @(posedge clk) begin
    if (mem_write) begin
      if (be[0]) mem[idx][7:0] <= wshift[7:0];
      if (be[1]) mem[idx][15:8] <= wshift[15:8];
      if (be[2]) mem[idx][23:16] <= wshift[23:16];
      if (be[3]) mem[idx][31:24] <= wshift[31:24];
    end
  end

  word_t word;
  assign word = mem[idx];

  word_t shifted;
  assign shifted = word >> (off * 8);

  always_comb begin
    case (funct3)
      3'b000:  rdata = {{24{shifted[7]}}, shifted[7:0]};
      3'b001:  rdata = {{16{shifted[15]}}, shifted[15:0]};
      3'b010:  rdata = word;
      3'b100:  rdata = {24'b0, shifted[7:0]};
      3'b101:  rdata = {16'b0, shifted[15:0]};
      default: rdata = word;
    endcase
  end
endmodule
