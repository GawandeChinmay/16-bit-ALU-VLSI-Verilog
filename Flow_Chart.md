## Architecture Overview

The block diagram below illustrates the top-level datapath and flag-generation logic of the 16-bit ALU.

<img width="4534" height="2644" alt="Flow Chart" src="https://github.com/user-attachments/assets/c08d0ebc-1798-4a3c-80fc-8e973379f522" />

### Datapath

The ALU accepts two 16-bit operands (`A`, `B`) and a 4-bit `opcode`. The opcode is decoded into two fields:

- **`group_sel[1:0]`** — selects which functional unit is active (`2'b00` = Arithmetic, `2'b01` = Logic, `2'b10` = Shift)
- **`sub_op[1:0]`** — selects the specific operation within that unit

All three units compute in parallel. The `mux_unit` then routes the result of the active unit to the final 16-bit output based on `group_sel`.

### Flag Generation

Four status flags are derived from the selected result:

| Flag | Condition |
|------|-----------|
| **ZF** (Zero) | Set when the 16-bit result is `0x0000` |
| **NF** (Negative) | Set when MSB of the result is `1` (two's complement sign bit) |
| **CF** (Carry) | Set when the arithmetic unit produces a carry-out beyond bit 15 |
| **OVF** (Overflow) | Set when signed overflow is detected — i.e., two operands of the same sign produce a result of opposite sign |

> **Note:** CF is generated exclusively by the Arithmetic unit and is forwarded directly as a status output. OVF detection uses the sign bits of both operands and the result to identify illegal signed additions and subtractions.
