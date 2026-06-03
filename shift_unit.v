// ============================================================
// Module: shift_unit.v
// Description: Handles LSL, LSR, ROL, ROR (rotate) operations
// Improvement #3: Added rotate operations
// Improvement #4: Modular design - separate shift block
// ============================================================

module shift_unit (
    input  [15:0] A,
    input  [1:0]  shift_op,  // 00=LSL, 01=LSR, 10=ROL, 11=ROR
    output reg [15:0] shift_result
);

    always @(*) begin
        case (shift_op)
            2'b00: shift_result = A << 1;              // Logical Shift Left
            2'b01: shift_result = A >> 1;              // Logical Shift Right
            2'b10: shift_result = {A[14:0], A[15]};   // Rotate Left
            2'b11: shift_result = {A[0], A[15:1]};    // Rotate Right
            default: shift_result = 16'b0;
        endcase
    end

endmodule
