`timescale 1ns / 1ps

module riscv_cpu (
    input wire clk,
    input wire reset,

    output wire [31:0] debug_pc,
    output wire [31:0] debug_alu_result,
    output wire [31:0] debug_write_back
);

wire [31:0] pc;
wire [31:0] next_pc;
wire [31:0] instruction;

wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;

wire [31:0] read_data1;
wire [31:0] read_data2;
wire [31:0] immediate;

wire reg_write;
wire alu_src;
wire mem_write;
wire mem_read;
wire mem_to_reg;
wire branch;
wire [1:0] alu_op;

wire [3:0] alu_control_signal;
wire [31:0] alu_input_b;
wire [31:0] alu_result;
wire zero;

wire [31:0] memory_read_data;
wire [31:0] write_back_data;

wire [31:0] pc_plus_4;
wire [31:0] branch_target;
wire take_branch;

// Program Counter
program_counter pc_module (
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc(pc)
);


// Instruction Memory
instruction_memory instruction_memory_module (
    .address(pc),
    .instruction(instruction)
);


// Extract register numbers from instruction
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign rd  = instruction[11:7];


// Move to next instruction
assign pc_plus_4 = pc + 32'd4;
assign branch_target = pc + immediate;
assign take_branch = branch & zero;
assign next_pc = take_branch ? branch_target : pc_plus_4;

// Control Unit
control_unit control_module (
    .opcode(instruction[6:0]),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .mem_to_reg(mem_to_reg),
    .branch(branch),
    .alu_op(alu_op)
);

// Immediate Generator
immediate_generator immediate_module (
    .instruction(instruction),
    .immediate(immediate)
);

// Register File
register_file register_module (
    .clk(clk),
    .reg_write(reg_write),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .write_data(write_back_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// ALU Control
alu_control alu_control_module (
    .alu_op(alu_op),
    .funct3(instruction[14:12]),
    .funct7_bit30(instruction[30]),
    .alu_control(alu_control_signal)
);

assign alu_input_b = alu_src ? immediate : read_data2;

// ALU
alu alu_module (
    .a(read_data1),
    .b(alu_input_b),
    .alu_control(alu_control_signal),
    .result(alu_result),
    .zero(zero)
);

// Data Memory
data_memory data_memory_module (
    .clk(clk),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .address(alu_result),
    .write_data(read_data2),
    .read_data(memory_read_data)
);

// Write-back selection
assign write_back_data = mem_to_reg ? memory_read_data : alu_result;

// Debug outputs
assign debug_pc = pc;
assign debug_alu_result = alu_result;
assign debug_write_back = write_back_data;

endmodule
