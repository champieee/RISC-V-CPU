`timescale 1ns / 1ps

module data_memory (
    input wire clk,
    input wire mem_write,
    input wire mem_read,

    input wire [31:0] address,
    input wire [31:0] write_data,

    output reg [31:0] read_data
);

reg [31:0] memory [0:255];

// Write on rising clock edge
always @(posedge clk) begin
    if (mem_write)
        memory[address[9:2]] <= write_data;
end

// Read combinationally
always @(*) begin
    if (mem_read)
        read_data = memory[address[9:2]];
    else
        read_data = 32'b0;
end

endmodule
