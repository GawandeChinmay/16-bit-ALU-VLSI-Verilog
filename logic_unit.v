// ============================================================
// Module: logic_unit.v
// Description: Handles AND, OR, XOR, NAND, NOR, XNOR, NOT operations
// Improvement #3: Expanded to 7 logic operations
// Improvement #4: Modular design - separate logic block
// ============================================================

module logic_unit (
    input  [15:0] A,
    input  [15:0] B,
    input  [2:0]  logic_op,   // 000=AND, 001=OR, 010=XOR, 011=NAND
                               // 100=NOR, 101=XNOR, 110=NOT A
    output reg [15:0] logic_result
);

    always @(*) begin
        case (logic_op)
            3'b000: logic_result = A & B;    // AND
            3'b001: logic_result = A | B;    // OR
            3'b010: logic_result = A ^ B;    // XOR
            3'b011: logic_result = ~(A & B); // NAND
            3'b100: logic_result = ~(A | B); // NOR
            3'b101: logic_result = ~(A ^ B); // XNOR
            3'b110: logic_result = ~A;       // NOT A
            default: logic_result = 16'b0;
        endcase
    end

endmodule
