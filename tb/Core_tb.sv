`timescale 1ns / 1ps

module Core_tb;
  logic clk = 0;
  logic rst = 1;

  always #5 clk = ~clk;

  Core dut (
    .clk(clk),
    .rst(rst)
  );

  initial begin
    repeat (3) @(posedge clk);
    rst <= 0;

    repeat (20) @(posedge clk);

    if (dut.regfile.regs[3] == 32'd8 && dut.regfile.regs[4] == 32'd8) $display("PASS");
    else $display("FAIL: x3 = %0d, x4 = %0d", dut.regfile.regs[3], dut.regfile.regs[4]);
    $finish;
  end
endmodule
