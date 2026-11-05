`timescale 1ns / 1ps

module ALU
  import cpu_pkg::*;
(
  input  word_t a,
  input  word_t b,
  output word_t out,

  input alu_op_t op
);

  always_comb begin
    case (op)
      ALU_ADD:  out = a + b;
      ALU_SUB:  out = a - b;
      ALU_SLL:  out = a << b[4:0];
      ALU_SLT:  out = {31'b0, $signed(a) < $signed(b)};
      ALU_SLTU: out = {31'b0, a < b};
      ALU_XOR:  out = a ^ b;
      ALU_SRL:  out = a >> b[4:0];
      ALU_SRA:  out = $signed(a) >>> b[4:0];
      ALU_OR:   out = a | b;
      ALU_AND:  out = a & b;
      default:  out = '0;
    endcase
  end
endmodule
