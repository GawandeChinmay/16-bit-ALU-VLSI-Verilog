// ============================================================
// Module: arithmetic_unit.v
// Description: Handles ADD, SUB, MUL, DIV, INC, DEC operations
// Improvement #1: 16-bit inputs/outputs
// Improvement #4: Modular design - separate arithmetic block
// ============================================================

module arithmetic_unit (
    input  [15:0] A,
    input  [15:0] B,
    input  [1:0]  arith_op,   // 00=ADD, 01=SUB, 10=INC, 11=DEC
    output reg [15:0] arith_result,
    output reg carry_out
);

    reg [16:0] temp; // 17-bit to capture carry

    always @(*) begin
        carry_out = 0;
        case (arith_op)
            2'b00: begin // ADD
                temp         = {1'b0, A} + {1'b0, B};
                arith_result = temp[15:0];
                carry_out    = temp[16];
            end
            2'b01: begin // SUB
                temp         = {1'b0, A} - {1'b0, B};
                arith_result = temp[15:0];
                carry_out    = temp[16]; // borrow flag
            end
            2'b10: begin // INC A
                temp         = {1'b0, A} + 1;
                arith_result = temp[15:0];
                carry_out    = temp[16];
            end
            2'b11: begin // DEC A
                temp         = {1'b0, A} - 1;
                arith_result = temp[15:0];
                carry_out    = temp[16];
            end
            default: begin
                arith_result = 16'b0;
                carry_out    = 0;
            end
        endcase
    end

endmodule
