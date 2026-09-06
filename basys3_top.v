`timescale 1ns / 1ps

module basys3_top (
    input wire clk,
    input wire reset,
    output wire [15:0] led
);

wire [31:0] debug_pc;
wire [31:0] debug_alu_result;
wire [31:0] debug_write_back;

riscv_cpu cpu (
    .clk(clk),
    .reset(reset),
    .debug_pc(debug_pc),
    .debug_alu_result(debug_alu_result),
    .debug_write_back(debug_write_back)
);

// Show lower 16 bits of write-back result on LEDs
assign led = debug_write_back[15:0];

endmodule
