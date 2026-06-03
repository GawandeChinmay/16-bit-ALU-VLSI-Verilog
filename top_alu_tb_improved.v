// ============================================================
// Module: top_alu_tb.v  (IMPROVED TESTBENCH)
// Project: 16-bit ALU — Improved Frontend VLSI Project
//
// IMPROVEMENTS IN THIS TESTBENCH:
//   1. All 4 flags checked in every test case
//   2. Dedicated carry flag test cases added
//   3. Dedicated overflow flag test cases added
//   4. Better FAIL message showing all flags
//   5. More edge case tests added
// ============================================================

`timescale 1ns/1ps

module top_alu_tb;

    // ---- Inputs ----
    reg  [15:0] A;
    reg  [15:0] B;
    reg  [3:0]  opcode;

    // ---- Outputs ----
    wire [15:0] result;
    wire        zero_flag;
    wire        carry_flag;
    wire        negative_flag;
    wire        overflow_flag;

    // ---- Instantiate DUT (Device Under Test) ----
    top_alu DUT (
        .A            (A),
        .B            (B),
        .opcode       (opcode),
        .result       (result),
        .zero_flag    (zero_flag),
        .carry_flag   (carry_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag)
    );

    // ---- Pass/Fail counter ----
    integer pass_count;
    integer fail_count;

    // ============================================================
    // IMPROVED CHECK TASK — Now checks ALL 4 flags
    // ============================================================
    task check;
        input [15:0] expected_result;
        input        exp_zero;
        input        exp_carry;
        input        exp_neg;
        input        exp_ovf;
        input [79:0] op_name;
        begin
            // ✅ IMPROVEMENT: Now checks carry_flag and overflow_flag too
            if (result        !== expected_result ||
                zero_flag     !== exp_zero        ||
                carry_flag    !== exp_carry       ||
                negative_flag !== exp_neg         ||
                overflow_flag !== exp_ovf) begin

                // Detailed FAIL message showing expected vs got for ALL flags
                $display("FAIL | op=%04b (%s) | A=0x%04h B=0x%04h",
                          opcode, op_name, A, B);
                $display("       Result  → Got: %0d  | Expected: %0d  %s",
                          result, expected_result,
                          (result !== expected_result) ? "❌" : "✅");
                $display("       Zero    → Got: %b    | Expected: %b    %s",
                          zero_flag, exp_zero,
                          (zero_flag !== exp_zero) ? "❌" : "✅");
                $display("       Carry   → Got: %b    | Expected: %b    %s",
                          carry_flag, exp_carry,
                          (carry_flag !== exp_carry) ? "❌" : "✅");
                $display("       Neg     → Got: %b    | Expected: %b    %s",
                          negative_flag, exp_neg,
                          (negative_flag !== exp_neg) ? "❌" : "✅");
                $display("       Ovflow  → Got: %b    | Expected: %b    %s",
                          overflow_flag, exp_ovf,
                          (overflow_flag !== exp_ovf) ? "❌" : "✅");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS | op=%04b (%s) | A=0x%04h B=0x%04h => Result=%0d | Z=%b C=%b N=%b OVF=%b",
                          opcode, op_name, A, B, result,
                          zero_flag, carry_flag, negative_flag, overflow_flag);
                pass_count = pass_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("top_alu_tb.vcd");
        $dumpvars(0, top_alu_tb);

        pass_count = 0;
        fail_count = 0;

        $display("======================================================");
        $display("  16-bit ALU Improved Testbench — All Ops & All Flags");
        $display("======================================================");

        // ============================================================
        // ARITHMETIC OPERATIONS — Normal Cases
        // ============================================================
        $display("\n--- ARITHMETIC (Normal Cases) ---");
        A = 16'd100; B = 16'd55;

        // ADD: 100+55=155 | Z=0 C=0 N=0 OVF=0
        opcode = 4'b0000; #10;
        check(16'd155, 0, 0, 0, 0, "ADD       ");

        // SUB: 100-55=45 | Z=0 C=0 N=0 OVF=0
        opcode = 4'b0001; #10;
        check(16'd45, 0, 0, 0, 0, "SUB       ");

        // INC: 100+1=101 | Z=0 C=0 N=0 OVF=0
        opcode = 4'b0010; #10;
        check(16'd101, 0, 0, 0, 0, "INC       ");

        // DEC: 100-1=99 | Z=0 C=0 N=0 OVF=0
        opcode = 4'b0011; #10;
        check(16'd99, 0, 0, 0, 0, "DEC       ");

        // ============================================================
        // ARITHMETIC — ZERO FLAG TESTS
        // ============================================================
        $display("\n--- ARITHMETIC (Zero Flag Tests) ---");

        // ADD: 0+0=0 → zero=1
        A = 16'd0; B = 16'd0;
        opcode = 4'b0000; #10;
        check(16'd0, 1, 0, 0, 0, "ADD_ZERO  ");

        // SUB: 50-50=0 → zero=1
        A = 16'd50; B = 16'd50;
        opcode = 4'b0001; #10;
        check(16'd0, 1, 0, 0, 0, "SUB_ZERO  ");

        // ============================================================
        // ARITHMETIC — CARRY FLAG TESTS ✅ NEW
        // ============================================================
        $display("\n--- ARITHMETIC (Carry Flag Tests) ---");

        // ADD: 0xFFFF + 1 = 0x0000 → carry=1 zero=1
        A = 16'hFFFF; B = 16'h0001;
        opcode = 4'b0000; #10;
        check(16'h0000, 1, 1, 0, 0, "ADD_CARRY ");

        // ADD: 0xFFFF + 0xFFFF → carry=1
        A = 16'hFFFF; B = 16'hFFFF;
        opcode = 4'b0000; #10;
        check(16'hFFFE, 0, 1, 1, 0, "ADD_CARRY2");

        // SUB: 0x0000 - 1 → borrow=1 (carry=1)
        A = 16'h0000; B = 16'h0001;
        opcode = 4'b0001; #10;
        check(16'hFFFF, 0, 1, 1, 0, "SUB_BORROW");

        // ============================================================
        // ARITHMETIC — OVERFLOW FLAG TESTS ✅ NEW
        // ============================================================
        $display("\n--- ARITHMETIC (Overflow Flag Tests) ---");

        // ADD: +32767 + 1 = -32768 → overflow=1 (pos+pos=neg)
        A = 16'h7FFF; B = 16'h0001;
        opcode = 4'b0000; #10;
        check(16'h8000, 0, 0, 1, 1, "ADD_OVF+  ");

        // ADD: -32768 + -1 = +32767 → overflow=1 (neg+neg=pos)
        A = 16'h8000; B = 16'hFFFF;
        opcode = 4'b0000; #10;
        check(16'h7FFF, 0, 1, 0, 1, "ADD_OVF-  ");

        // SUB: +32767 - (-1) = -32768 → overflow=1 (pos-neg=neg)
        A = 16'h7FFF; B = 16'hFFFF;
        opcode = 4'b0001; #10;
        check(16'h8000, 0, 1, 1, 1, "SUB_OVF+  ");

        // SUB: -32768 - 1 = +32767 → overflow=1 (neg-pos=pos)
        A = 16'h8000; B = 16'h0001;
        opcode = 4'b0001; #10;
        check(16'h7FFF, 0, 1, 0, 1, "SUB_OVF-  ");

        // ============================================================
        // ARITHMETIC — NEGATIVE FLAG TESTS
        // ============================================================
        $display("\n--- ARITHMETIC (Negative Flag Tests) ---");

        // SUB: 10 - 20 = negative result
        A = 16'd10; B = 16'd20;
        opcode = 4'b0001; #10;
        check(16'hFFF6, 0, 1, 1, 0, "SUB_NEG   ");

        // ============================================================
        // LOGIC OPERATIONS
        // ============================================================
        $display("\n--- LOGIC OPERATIONS ---");
        A = 16'hF0F0; B = 16'hFF00;

        // AND: F0F0 & FF00 = F000 | N=1 (MSB=1)
        opcode = 4'b0100; #10;
        check(16'hF000, 0, 0, 1, 0, "AND       ");

        // OR: F0F0 | FF00 = FFF0 | N=1
        opcode = 4'b0101; #10;
        check(16'hFFF0, 0, 0, 1, 0, "OR        ");

        // XOR: F0F0 ^ FF00 = 0FF0 | N=0
        opcode = 4'b0110; #10;
        check(16'h0FF0, 0, 0, 0, 0, "XOR       ");

        // NAND: ~(F0F0 & FF00) = ~F000 = 0FFF | N=0
        opcode = 4'b0111; #10;
        check(16'h0FFF, 0, 0, 0, 0, "NAND      ");

        // NOR: ~(F0F0 | FF00) = ~FFF0 = 000F | N=0
        opcode = 4'b1000; #10;
        check(16'h000F, 0, 0, 0, 0, "NOR       ");

        // XNOR: ~(F0F0 ^ FF00) = ~0FF0 = F00F | N=1
        opcode = 4'b1001; #10;
        check(16'hF00F, 0, 0, 1, 0, "XNOR      ");

        // NOT: ~F0F0 = 0F0F | N=0
        opcode = 4'b1010; #10;
        check(16'h0F0F, 0, 0, 0, 0, "NOT       ");

        // ---- Logic Zero Flag test ----
        // AND: 0000 & 0000 = 0000 → zero=1
        A = 16'h0000; B = 16'h0000;
        opcode = 4'b0100; #10;
        check(16'h0000, 1, 0, 0, 0, "AND_ZERO  ");

        // ============================================================
        // SHIFT OPERATIONS
        // ============================================================
        $display("\n--- SHIFT OPERATIONS ---");
        A = 16'b1010_1010_1010_1010; B = 16'b0;

        // LSL: shift left → MSB lost, LSB=0
        opcode = 4'b1011; #10;
        check(16'b0101_0101_0101_0100, 0, 0, 0, 0, "LSL       ");

        // LSR: shift right → LSB lost, MSB=0
        opcode = 4'b1100; #10;
        check(16'b0101_0101_0101_0101, 0, 0, 0, 0, "LSR       ");

        // ROL: rotate left → MSB wraps to LSB
        opcode = 4'b1101; #10;
        check(16'b0101_0101_0101_0101, 0, 0, 0, 0, "ROL       ");

        // ROR: rotate right → LSB wraps to MSB
        opcode = 4'b1110; #10;
        check(16'b0101_0101_0101_0101, 0, 0, 0, 0, "ROR       ");

        // ---- Shift Zero Flag test ----
        A = 16'h0001; B = 16'h0000;
        opcode = 4'b1100; #10; // LSR: 0001 >> 1 = 0000 → zero=1
        check(16'h0000, 1, 0, 0, 0, "LSR_ZERO  ");

        // ---- Shift Negative Flag test ----
        A = 16'h0001; B = 16'h0000;
        opcode = 4'b1110; #10; // ROR: LSB(1) wraps to MSB → negative=1
        check(16'h8000, 0, 0, 1, 0, "ROR_NEG   ");

        // ============================================================
        // PASS OPERATION
        // ============================================================
        $display("\n--- PASS OPERATION ---");

        // PASS: A=0xABCD → result=0xABCD | N=1
        A = 16'hABCD; B = 16'h0000;
        opcode = 4'b1111; #10;
        check(16'hABCD, 0, 0, 1, 0, "PASS      ");

        // PASS: A=0x0000 → zero=1
        A = 16'h0000; B = 16'hFFFF;
        opcode = 4'b1111; #10;
        check(16'h0000, 1, 0, 0, 0, "PASS_ZERO ");

        // ============================================================
        // FINAL SUMMARY
        // ============================================================
        $display("\n======================================================");
        $display("   FINAL RESULTS: %0d PASSED | %0d FAILED", pass_count, fail_count);
        if (fail_count == 0)
            $display("   ALL TESTS PASSED SUCCESSFULLY ✅");
        else
            $display("   %0d TESTS FAILED — CHECK ABOVE FOR DETAILS ❌", fail_count);
        $display("======================================================");

        $finish;
    end

endmodule
