// ============================================================
// Module: mux_unit.v
// Description: Selects the final output from arithmetic, logic,
//              or shift unit based on group selector
// Improvement #4: Modular design - top-level multiplexer
// ============================================================

module mux_unit (
    input  [15:0] arith_result,
    input  [15:0] logic_result,
    input  [15:0] shift_result,
    input  [1:0]  group_sel,    // 00=Arithmetic, 01=Logic, 10=Shift
    output reg [15:0] mux_out
);

    always @(*) begin
        case (group_sel)
            2'b00: mux_out = arith_result;
            2'b01: mux_out = logic_result;
            2'b10: mux_out = shift_result;
            default: mux_out = 16'b0;
        endcase
    end

endmodule
