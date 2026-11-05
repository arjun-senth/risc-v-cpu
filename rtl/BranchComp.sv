`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10/12/2026 05:19:39 PM
// Design Name:
// Module Name: BranchComp
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module BranchComp
  import cpu_pkg::*;
(
  input  word_t       rs1,
  input  word_t       rs2,
  input  logic  [2:0] funct,
  output logic        taken
);
  always_comb begin
    case (funct)
      3'b000:  taken = (rs1 == rs2);
      3'b001:  taken = (rs1 != rs2);
      3'b100:  taken = ($signed(rs1) < $signed(rs2));
      3'b101:  taken = ($signed(rs1) >= $signed(rs2));
      3'b110:  taken = (rs1 < rs2);
      3'b111:  taken = (rs1 >= rs2);
      default: taken = 1'b0;
    endcase
  end
endmodule
