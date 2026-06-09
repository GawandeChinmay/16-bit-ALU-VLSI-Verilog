## Simulation Results

All test cases were validated using a self-checking testbench (`top_alu_tb.v`) that
automatically compares actual vs expected output. Final result: **16 tests passed,
0 failures**.

---

### Arithmetic Unit — ADD Operation

#### 1. Basic ADD
<img width="1581" height="815" alt="Basic_ADD" src="https://github.com/user-attachments/assets/c08c1d92-e772-4112-852b-daab1b2908e3" />

Validates fundamental addition. `A=0x0064 + B=0x0037 = 0x009B` (100 + 55 = 155).
All flags deasserted confirming no boundary conditions triggered.

---

#### 2. ADD — Zero Flag
<img width="1583" height="825" alt="ZeroFlag_ADD" src="https://github.com/user-attachments/assets/03327398-abea-4f75-b287-97dab402e05f" />

`A=0x0000 + B=0x0000 = 0x0000`. Zero flag asserts when result is exactly zero.
All other flags remain deasserted.

---

#### 3. ADD — Zero + Carry Flags
<img width="1586" height="815" alt="ADD_ZF_CF" src="https://github.com/user-attachments/assets/4a4a4674-a641-4ec5-80e9-77b8ddcf4e86" />

`A=0xFFFF + B=0x0001 = 0x0000`. The 17-bit sum wraps to zero triggering the Zero
flag, while the carry-out asserts the Carry flag simultaneously. Waveform captures
the live transition between two test cases.

---

#### 4. ADD — Carry + Negative Flags
<img width="1582" height="821" alt="ADD_CF_NF" src="https://github.com/user-attachments/assets/3e5f93da-30f6-4bab-8cf5-913293a22328" />

`A=0xFFFF + B=0xFFFF = 0xFFFE`. Carry flag asserts due to 16-bit unsigned overflow.
Negative flag asserts as the MSB of the result is 1.

---

#### 5. ADD — Negative + Overflow Flags
<img width="1583" height="825" alt="ADD_NF_OF" src="https://github.com/user-attachments/assets/5917208d-e118-4dcf-a154-75f079aaf7d6" />

`A=0x7FFF + B=0x0001 = 0x8000`. The canonical signed overflow case: adding 1 to the
maximum positive 16-bit value (+32767) wraps to the minimum negative value (-32768).
Overflow flag correctly asserts alongside the Negative flag.

---

#### 6. ADD — Carry + Overflow Flags
<img width="1587" height="822" alt="ADD_CF_OF" src="https://github.com/user-attachments/assets/c71a8645-3e43-4471-995b-fefa2411fb64" />

`A=0x8000 + B=0xFFFF = 0x7FFF`. Two negative operands produce a positive result,
violating signed arithmetic rules and asserting the Overflow flag. Carry flag asserts
due to the unsigned 17-bit result. Both flags verified simultaneously.

---

### Arithmetic Unit — SUB Operation

#### 7. SUB — Zero Flag
<img width="1587" height="818" alt="SUB_ZF" src="https://github.com/user-attachments/assets/e37e6058-8333-40ae-9ebf-7b4061ba4dce" />

`A=0x0032 - B=0x0032 = 0x0000`. Subtracting equal operands yields zero, asserting
only the Zero flag. All other flags remain deasserted.

---

#### 8. SUB — Overflow Flag Only

<img width="1587" height="816" alt="SUB_OF" src="https://github.com/user-attachments/assets/bce1c6be-dcc9-4566-8cbe-f8b47f3edc6c" />

`A=0x8000 - B=0x0001 = 0x7FFF`. Subtracting 1 from the minimum signed value (-32768)
wraps to the maximum positive value (+32767). Only the Overflow flag asserts —
Carry and Negative remain deasserted, demonstrating precise flag isolation.

---

#### 9. SUB — Carry + Negative + Overflow Flags
<img width="1582" height="822" alt="SUB_CF_NF_OF" src="https://github.com/user-attachments/assets/101421ce-1ddf-4122-a01d-7be3b1399bf3" />

`A=0x7FFF - B=0xFFFF = 0x8000`. All three flags assert simultaneously: Carry due to
unsigned borrow, Negative as MSB=1, and Overflow because subtracting a negative from
a positive yields a negative result — a signed arithmetic violation.

---

### Test Summary

| # | Operation | A | B | Result | ZF | CF | NF | OVF |
|---|-----------|--------|--------|--------|----|----|----|----|
| 1 | ADD | 0x0064 | 0x0037 | 0x009B | 0 | 0 | 0 | 0 |
| 2 | ADD | 0x0000 | 0x0000 | 0x0000 | 1 | 0 | 0 | 0 |
| 3 | ADD | 0xFFFF | 0x0001 | 0x0000 | 1 | 1 | 0 | 0 |
| 4 | ADD | 0xFFFF | 0xFFFF | 0xFFFE | 0 | 1 | 1 | 0 |
| 5 | ADD | 0x7FFF | 0x0001 | 0x8000 | 0 | 0 | 1 | 1 |
| 6 | ADD | 0x8000 | 0xFFFF | 0x7FFF | 0 | 1 | 0 | 1 |
| 7 | SUB | 0x0032 | 0x0032 | 0x0000 | 1 | 0 | 0 | 0 |
| 8 | SUB | 0x8000 | 0x0001 | 0x7FFF | 0 | 0 | 0 | 1 |
| 9 | SUB | 0x7FFF | 0xFFFF | 0x8000 | 0 | 1 | 1 | 1 |
