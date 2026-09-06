`timescale 1ns / 1ps

module control_unit (
    input wire [6:0] opcode,

    output reg reg_write,
    output reg alu_src,
    output reg mem_write,
    output reg mem_read,
    output reg mem_to_reg,
    output reg branch,
    output reg [1:0] alu_op
);

always @(*) begin

    // Safe defaults
    reg_write = 0;
    alu_src = 0;
    mem_write = 0;
    mem_read = 0;
    mem_to_reg = 0;
    branch = 0;
    alu_op = 2'b00;

    case (opcode)

        // R-type: add, sub, and, or, xor...
        7'b0110011: begin
            reg_write = 1;
            alu_src = 0;
            alu_op = 2'b10;
        end

        // I-type arithmetic: addi, andi, ori...
        7'b0010011: begin
            reg_write = 1;
            alu_src = 1;
            alu_op = 2'b11;
        end

        // Load: lw
        7'b0000011: begin
            reg_write = 1;
            alu_src = 1;
            mem_read = 1;
            mem_to_reg = 1;
            alu_op = 2'b00;
        end

        // Store: sw
        7'b0100011: begin
            alu_src = 1;
            mem_write = 1;
            alu_op = 2'b00;
        end

        // Branch: beq, bne...
        7'b1100011: begin
            branch = 1;
            alu_src = 0;
            alu_op = 2'b01;
        end

        default: begin
            // keep defaults
        end

    endcase

end

endmodule
