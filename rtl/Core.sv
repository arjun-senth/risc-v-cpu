`timescale 1ns / 1ps
`default_nettype none

module Core
  import cpu_pkg::*;
(
  input logic clk,
  input logic rst
);

  word_t pc_next, pc_addr;
  logic [31:0] instr;

  word_t immediate;

  logic [4:0] rs1_i, rs2_i, rd_i;
  logic [2:0] funct3;

  word_t rs1_d, rs2_d, rd_d;

  ctrl_t ctrl;

  // IF
  ProgramCounter program_counter (
    .clk(clk),
    .rst(rst),
    .pc_next(pc_next),
    .pc_addr(pc_addr)
  );

  InstrMem instr_mem (
    .addr (pc_addr),
    .instr(instr)
  );

  wire take_branch = ctrl.branch & taken;
  always_comb begin
    if (ctrl.jalr) pc_next = alu_out & ~word_t'(1);
    else if (ctrl.jal || take_branch) pc_next = pc_addr + immediate;
    else pc_next = pc_addr + 4;
  end

  // ID
  Decoder decoder (
    .instr(instr),
    .rs1(rs1_i),
    .rs2(rs2_i),
    .rd(rd_i),
    .funct3(funct3),
    .ctrl(ctrl)
  );

  RegisterFile regfile (
    .clk(clk),
    .rs1_addr(rs1_i),
    .rs2_addr(rs2_i),
    .rs1_data(rs1_d),
    .rs2_data(rs2_d),
    .we(ctrl.reg_write),
    .rd_addr(rd_i),
    .rd_data(rd_d)
  );

  ImmediateGen immediate_gen (
    .instr(instr),
    .immediate(immediate)
  );

  // EX
  word_t alu_a, alu_b;
  word_t alu_out;

  always_comb begin
    case (ctrl.alu_a_sel)
      ALU_A_RS1: alu_a = rs1_d;
      ALU_A_PC: alu_a = pc_addr;
      ALU_A_ZERO: alu_a = '0;
      default: alu_a = '0;
    endcase
  end

  always_comb begin
    case (ctrl.alu_b_sel)
      ALU_B_RS2: alu_b = rs2_d;
      ALU_B_IMM: alu_b = immediate;
      default:   alu_b = '0;
    endcase
  end

  ALU alu (
    .a  (alu_a),
    .b  (alu_b),
    .op (ctrl.alu_op),
    .out(alu_out)
  );

  wire taken;

  BranchComp branch_comp (
    .rs1  (rs1_d),
    .rs2  (rs2_d),
    .funct(funct3),
    .taken(taken)
  );

  word_t rdata;

  // MEM
  DataMem data_mem (
    .clk(clk),
    .mem_write(ctrl.mem_write),
    .mem_read(ctrl.mem_read),
    .funct3(funct3),
    .addr(alu_out),
    .wdata(rs2_d),
    .rdata(rdata)
  );

  // WB
  always_comb begin
    case (ctrl.result_sel)
      RESULT_SEL_ALU: rd_d = alu_out;
      RESULT_SEL_MEM: rd_d = rdata;
      RESULT_SEL_PC4: rd_d = pc_addr + 4;
      default: rd_d = alu_out;
    endcase
  end
endmodule

`default_nettype wire
