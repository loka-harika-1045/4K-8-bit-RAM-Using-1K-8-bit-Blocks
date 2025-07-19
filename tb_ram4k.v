`timescale 1ns/1ps
module tb_ram4k;
    reg clk = 0;
    always #5 clk = ~clk;

    reg we;
    reg [11:0] addr;
    reg [7:0] din;
    wire [7:0] dout;

    ram4k dut (.clk(clk), .we(we), .addr(addr), .din(din), .dout(dout));

    integer i;
    initial begin
        we = 1;
        for (i=0; i<4096; i=i+1) begin
            addr = i;
            din = i[7:0] ^ 8'hA5;  // sample data
            #10;
            if (dout !== din) $display("WRITE ERR at %0d: dout=%h expected=%h", i, dout, din);
        end
        we = 0;
        for (i=0; i<4096; i=i+1) begin
            addr = i;
            #10;
            if (dout !== (i[7:0] ^ 8'hA5))
                $display("READ ERR at %0d: dout=%h expected=%h", i, dout, (i[7:0]^8'hA5));
        end
        $display("RAM4K test complete");
        $finish;
    end
endmodule
