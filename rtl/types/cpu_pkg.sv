`timescale 1ns / 1ps

package cpu_pkg;
  parameter int XLEN = 32;

  typedef logic [XLEN-1:0] word_t;

  typedef enum logic [3:0] {
    ALU_ADD  = 4'b0_000,
    ALU_SUB  = 4'b1_000,
    ALU_SLL  = 4'b0_001,
    ALU_SLT  = 4'b0_010,
    ALU_SLTU = 4'b0_011,
    ALU_XOR  = 4'b0_100,
    ALU_SRL  = 4'b0_101,
    ALU_SRA  = 4'b1_101,
    ALU_OR   = 4'b0_110,
    ALU_AND  = 4'b0_111
  } alu_op_t;

  typedef enum logic [1:0] {
    ALU_A_RS1  = 2'b00,
    ALU_A_PC   = 2'b01,
    ALU_A_ZERO = 2'b10
  } alu_a_e;

  typedef enum logic {
    ALU_B_RS2 = 'b0,
    ALU_B_IMM = 1'b1
  } alu_b_e;

  typedef enum logic [1:0] {
    RESULT_SEL_ALU = 2'b00,
    RESULT_SEL_MEM = 2'b01,
    RESULT_SEL_PC4 = 2'b10
  } result_sel_e;

  typedef struct packed {
    logic reg_write;

    alu_a_e  alu_a_sel;
    alu_b_e  alu_b_sel;
    alu_op_t alu_op;

    logic mem_read;
    logic mem_write;

    result_sel_e result_sel;

    logic branch;
    logic jalr;
    logic jal;
  } ctrl_t;

  typedef enum logic [6:0] {
    OP = 7'b0110011,
    OP_IMM = 7'b0010011,
    LOAD = 7'b0000011,
    STORE = 7'b0100011,
    BRANCH = 7'b1100011,
    JAL = 7'b1101111,
    JALR = 7'b1100111,
    LUI = 7'b0110111,
    AUIPC = 7'b0010111,
    MISC_MEM = 7'b0001111,
    SYSTEM = 7'b1110011
  } opcode_t;
endpackage
