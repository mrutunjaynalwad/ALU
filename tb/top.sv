`include "assertion.sv"
`include "alu_pkg.sv"

module top;
  import uvm_pkg::*;
  import tb_pkg::*;

  bit pclk;
  bit prst;
  always #5 pclk=~pclk;

  initial begin
    $display("Top");
    //prst=1;
    // #10;
     prst=0;
  end

  intf vif(.clk(pclk),.rst(prst));

  ALU_DESIGN dut(.CLK(vif.clk),
         .RST(vif.rst),
         .OPA (vif.opa),
          .OPB(vif.opb),
          .CMD(vif.cmd),
          .MODE(vif.mode),
          .CIN(vif.cin),
          .CE(vif.ce),
          .INP_VALID(vif.inp_valid),
          .RES(vif.res),
          .COUT(vif.cout),
          .OFLOW(vif.oflow),
          .G(vif.g),
          .L(vif.l),
          .E(vif.e),
          .ERR(vif.err));
 
bind intf assertions ASSERTINS_PROP(.clk(clk),
                                      .rst(rst),
                                      .ce(ce),
                                      .res(res),
                                      .mode(mode),
                                      .cmd(cmd),
                                      .opa(opa),
                                      .opb(opb),
                                      .cin(cin),
                                      .oflow(oflow),
                                      .cout(cout),
                                      .g(g),
                                      .l(l),
                                      .e(e),
                                      .err(err),
                                    .inp_valid(inp_valid));
 
  initial begin
    uvm_config_db #(virtual intf)::set(null,"uvm_test_top.*","vif",vif);
  end
 
  initial begin
    run_test("alu_test");
  end
endmodule
