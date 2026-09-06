`timescale 1ns / 1ps

module instruction_memory (
    input wire [31:0] address,
    output wire [31:0] instruction
);

reg [31:0] memory [0:255];

initial begin
    memory[0] = 32'h00500093; // addi x1, x0, 5
    memory[1] = 32'h00500113; // addi x2, x0, 5

    memory[2] = 32'h00208463; // beq  x1, x2, +8
    memory[3] = 32'h06300193; // addi x3, x0, 99   <- should be skipped
    memory[4] = 32'h00700193; // addi x3, x0, 7    <- branch target

    memory[5] = 32'h00000013; // nop
end

assign instruction = memory[address[9:2]];

endmodule