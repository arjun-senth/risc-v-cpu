`timescale 1ns / 1ps

module Decoder
  import cpu_pkg::*;
(
    input  logic  [31:0] instr,
    output logic  [ 4:0] rs1,
    output logic  [ 4:0] rs2,
    output logic  [ 4:0] rd,
    output logic  [ 2:0] funct3,
    output ctrl_t        ctrl
);

  assign rs1    = instr[19:15];
  assign rs2    = instr[24:20];
  assign rd     = instr[11:7];
  assign funct3 = instr[14:12];

  always_comb begin
    ctrl = '0;
    case (instr[6:0])
      OP: begin
        ctrl.reg_write = 1'b1;
        ctrl.alu_op = alu_op_t'({instr[30], funct3});
      end

      OP_IMM: begin
        ctrl.reg_write = 1'b1;
        ctrl.alu_b_sel = ALU_B_IMM;
        ctrl.alu_op = alu_op_t'({(funct3 == 3'b101) & instr[30], funct3});
      end

      LOAD: begin
        ctrl.reg_write  = 1'b1;
        ctrl.alu_b_sel  = ALU_B_IMM;
        ctrl.mem_read   = 1'b1;
        ctrl.result_sel = RESULT_SEL_MEM;
      end

      STORE: begin
        ctrl.mem_write = 1'b1;
        ctrl.alu_b_sel = ALU_B_IMM;
      end

      BRANCH: begin
        ctrl.branch = 1'b1;
      end

      JAL: begin
        ctrl.alu_a_sel = ALU_A_PC;
        ctrl.alu_b_sel = ALU_B_IMM;

        ctrl.reg_write = 1'b1;
        ctrl.jal = 1'b1;
        ctrl.result_sel = RESULT_SEL_PC4;
      end

      JALR: begin
        ctrl.alu_a_sel = ALU_A_RS1;
        ctrl.alu_b_sel = ALU_B_IMM;

        ctrl.reg_write = 1'b1;
        ctrl.jalr = 1'b1;
        ctrl.result_sel = RESULT_SEL_PC4;
      end

      LUI: begin
        ctrl.alu_a_sel = ALU_A_ZERO;
        ctrl.alu_b_sel = ALU_B_IMM;

        ctrl.reg_write = 1'b1;
      end

      AUIPC: begin
        ctrl.alu_a_sel = ALU_A_PC;
        ctrl.alu_b_sel = ALU_B_IMM;

        ctrl.reg_write = 1'b1;
      end

      MISC_MEM: begin
      end

      SYSTEM: begin
      end

      default: begin
      end
    endcase
  end
endmodule
