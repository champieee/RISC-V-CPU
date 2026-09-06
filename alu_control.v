`timescale 1ns / 1ps

module alu_control (
    input wire [1:0] alu_op,
    input wire [2:0] funct3,
    input wire funct7_bit30,

    output reg [3:0] alu_control
);

always @(*) begin

    case (alu_op)

        // lw / sw: always ADD for address calculation
        2'b00: begin
            alu_control = 4'b0000;
        end

        // branch: use SUB for comparison
        2'b01: begin
            alu_control = 4'b0001;
        end

        // R-type
        2'b10: begin
            case (funct3)

                3'b000: begin
                    if (funct7_bit30)
                        alu_control = 4'b0001; // SUB
                    else
                        alu_control = 4'b0000; // ADD
                end

                3'b111:
                    alu_control = 4'b0010; // AND

                3'b110:
                    alu_control = 4'b0011; // OR

                3'b100:
                    alu_control = 4'b0100; // XOR

                default:
                    alu_control = 4'b0000;

            endcase
        end

        // I-type arithmetic
        2'b11: begin
            case (funct3)

                3'b000:
                    alu_control = 4'b0000; // ADDI

                3'b111:
                    alu_control = 4'b0010; // ANDI

                3'b110:
                    alu_control = 4'b0011; // ORI

                3'b100:
                    alu_control = 4'b0100; // XORI

                default:
                    alu_control = 4'b0000;

            endcase
        end

        default:
            alu_control = 4'b0000;

    endcase

end

endmodule