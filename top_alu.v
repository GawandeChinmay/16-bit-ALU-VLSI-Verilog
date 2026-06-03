// ============================================================
// Module: top_alu.v  (TOP LEVEL)
// Project: 16-bit ALU — Improved Frontend VLSI Project
//
// IMPROVEMENTS APPLIED:
//   #1 — 16-bit inputs/outputs (upgraded from 8-bit)
//   #2 — Full 4-bit Flag Register: Zero, Carry, Negative, Overflow
//   #3 — 16 Operations using 4-bit opcode
//   #4 — Hierarchical modular design (arithmetic, logic, shift, mux)
//
// OPCODE TABLE (4-bit):
//   --- ARITHMETIC (group 00) ---
//   0000 = ADD     A + B
//   0001 = SUB     A - B
//   0010 = INC     A + 1
//   0011 = DEC     A - 1
//   --- LOGIC (group 01) ---
//   0100 = AND     A & B
//   0101 = OR      A | B
//   0110 = XOR     A ^ B
//   0111 = NAND    ~(A & B)
//   1000 = NOR     ~(A | B)
//   1001 = XNOR    ~(A ^ B)
//   1010 = NOT     ~A
//   --- SHIFT (group 10) ---
//   1011 = LSL     A << 1
//   1100 = LSR     A >> 1
//   1101 = ROL     Rotate Left
//   1110 = ROR     Rotate Right
//   1111 = PASS    A (passthrough)
// ============================================================

module top_alu (
    input  [15:0] A,           // Improvement #1: 16-bit input
    input  [15:0] B,           // Improvement #1: 16-bit input
    input  [3:0]  opcode,      // Improvement #3: 4-bit opcode = 16 operations
    output [15:0] result,      // Improvement #1: 16-bit output
    // Improvement #2: Full 4-flag register
    output        zero_flag,   // 1 when result == 0
    output        carry_flag,  // 1 on unsigned overflow/borrow
    output        negative_flag, // 1 when result is negative (MSB=1)
    output        overflow_flag  // 1 on signed overflow
);

    // ---- Internal wires ----
    wire [15:0] arith_result;
    wire [15:0] logic_result;
    wire [15:0] shift_result;
    wire [15:0] mux_out;
    wire        carry_out;

    // ---- Decode opcode into group and sub-operation ----
    wire [1:0] group_sel;
    wire [2:0] sub_op;

    // Group: 00=Arithmetic (0000-0011), 01=Logic (0100-1010), 10=Shift (1011-1111)
    assign group_sel = (opcode <= 4'b0011) ? 2'b00 :
                       (opcode <= 4'b1010) ? 2'b01 : 2'b10;

    // Sub-operation within each group
    assign sub_op = (group_sel == 2'b00) ? {1'b0, opcode[1:0]}  :  // arith: 0-3
                    (group_sel == 2'b01) ? (opcode - 4)          :  // logic: 0-6
                                           (opcode - 11);           // shift: 0-3

    // ---- Instantiate sub-modules (Improvement #4: Modular Design) ----

    arithmetic_unit AU (
        .A           (A),
        .B           (B),
        .arith_op    (sub_op[1:0]),
        .arith_result(arith_result),
        .carry_out   (carry_out)
    );

    logic_unit LU (
        .A            (A),
        .B            (B),
        .logic_op     (sub_op),
        .logic_result (logic_result)
    );

    shift_unit SU (
        .A            (A),
        .shift_op     (sub_op[1:0]),
        .shift_result (shift_result)
    );

    mux_unit MUX (
        .arith_result (arith_result),
        .logic_result (logic_result),
        .shift_result (shift_result),
        .group_sel    (group_sel),
        .mux_out      (mux_out)
    );

    // Handle PASS (opcode 1111)
    assign result = (opcode == 4'b1111) ? A : mux_out;

    // ---- Flag Generation (Improvement #2) ----

    // Zero Flag: result is all zeros
    assign zero_flag = (result == 16'b0) ? 1'b1 : 1'b0;

    // Carry Flag: from arithmetic unit (only valid for arithmetic ops)
    assign carry_flag = (group_sel == 2'b00) ? carry_out : 1'b0;

    // Negative Flag: MSB of result
    assign negative_flag = result[15];

    // Overflow Flag: signed overflow for ADD/SUB only
    // ADD overflow: pos + pos = neg, OR neg + neg = pos
    // SUB overflow: pos - neg = neg, OR neg - pos = pos
    assign overflow_flag = (opcode == 4'b0000) ?
                            (~A[15] & ~B[15] &  result[15]) |  // +A + +B = -result
                            ( A[15] &  B[15] & ~result[15]) :  // -A + -B = +result
                           (opcode == 4'b0001) ?
                            (~A[15] &  B[15] &  result[15]) |  // +A - -B = -result
                            ( A[15] & ~B[15] & ~result[15]) :  // -A - +B = +result
                            1'b0;

endmodule
