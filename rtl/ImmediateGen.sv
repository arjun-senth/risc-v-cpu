`timescale 1ns / 1ps

module ImmediateGen
  import cpu_pkg::*;
(
    input         [31:0] instr,
    output word_t        immediate
);
  always_comb begin
    case (instr[6:0])
      OP_IMM, LOAD, JALR: immediate = {{20{instr[31]}}, instr[31:20]};
      STORE: immediate = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      BRANCH: immediate = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
      LUI, AUIPC: immediate = {instr[31:12], 12'b0};
      JAL: immediate = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
      default: immediate = 32'b0;
    endcase
  end
endmodule
