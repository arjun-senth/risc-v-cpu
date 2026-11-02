`timescale 1ns / 1ps

module InstrMem
  import cpu_pkg::*;
#(
    parameter int    DEPTH = 4096,
    parameter string INIT = "program.mem"
) (
    input  word_t addr,
    output word_t instr
);

  word_t mem[DEPTH];
  initial $readmemh(INIT, mem);
  assign instr = mem[addr[$clog2(DEPTH)+1:2]];
endmodule
