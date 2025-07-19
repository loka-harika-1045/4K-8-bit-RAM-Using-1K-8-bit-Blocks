module ram1k (
    input clk,
    input we,
    input [9:0] addr,
    input [7:0] din,
    output reg [7:0] dout
);
    reg [7:0] mem [0:1023];
    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;
        dout <= mem[addr];
    end
endmodule

module ram4k (
    input clk,
    input we,
    input [11:0] addr,
    input [7:0] din,
    output [7:0] dout
);
    wire [7:0] dout0, dout1, dout2, dout3;
    wire we0 = we && (addr[11:10] == 2'b00);
    wire we1 = we && (addr[11:10] == 2'b01);
    wire we2 = we && (addr[11:10] == 2'b10);
    wire we3 = we && (addr[11:10] == 2'b11);

    ram1k r0(clk, we0, addr[9:0], din, dout0);
    ram1k r1(clk, we1, addr[9:0], din, dout1);
    ram1k r2(clk, we2, addr[9:0], din, dout2);
    ram1k r3(clk, we3, addr[9:0], din, dout3);

    assign dout = (addr[11:10] == 2'b00) ? dout0 :
                  (addr[11:10] == 2'b01) ? dout1 :
                  (addr[11:10] == 2'b10) ? dout2 :
                                           dout3;
endmodule
