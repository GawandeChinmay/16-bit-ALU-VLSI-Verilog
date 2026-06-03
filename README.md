# 16-bit-ALU-Frontend VLSI Project-Verilog
16-bit ALU design using Verilog HDL in Xilinx Vivado with modular architecture, 16 operations and 4-flag register
## Built in Xilinx Vivado | Verilog HDL

## 📌 Project Overview

This project presents a **16-bit Arithmetic Logic Unit (ALU)** designed using **Verilog HDL** and verified in **Xilinx Vivado**. The ALU supports **16 operations** across arithmetic, logic, and shift categories, along with a complete **4-flag register** (Zero, Carry, Negative, Overflow).

The design follows an **industry-standard modular hierarchical architecture**, separating functionality into dedicated sub-modules — exactly how real-world chips like ARM Cortex and RISC-V processors are designed.

---



## ✅ Improvements Applied

 #  Improvement 
 1  **16-bit ALU**:  Upgraded from 8-bit to 16-bit inputs/outputs 
 2  **4-Flag Register** : Zero, Carry, Negative, Overflow flags 
 3  **16 Operations**:  4-bit opcode — Arithmetic, Logic, Shift 
 4  **Modular Design** : Separate sub-modules: arithmetic, logic, shift, mux 

---
## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Xilinx Vivado** | RTL Design, Simulation, Synthesis, Implementation |
| **Verilog HDL** | Hardware Description Language |

## 📁 Project Files

```
VLSI_ALU_Project/
├── top_alu.v           ← TOP LEVEL MODULE (add as Design Source)
├── arithmetic_unit.v   ← Arithmetic sub-module
├── logic_unit.v        ← Logic sub-module
├── shift_unit.v        ← Shift sub-module
├── mux_unit.v          ← Output MUX sub-module
└── top_alu_tb.v        ← Testbench (add as Simulation Source)
```

---

## 🔢 Opcode Table (4-bit)

| Opcode | Operation | Expression |
|--------|-----------|------------|
| 0000   | ADD       | A + B      |
| 0001   | SUB       | A - B      |
| 0010   | INC       | A + 1      |
| 0011   | DEC       | A - 1      |
| 0100   | AND       | A & B      |
| 0101   | OR        | A \| B     |
| 0110   | XOR       | A ^ B      |
| 0111   | NAND      | ~(A & B)   |
| 1000   | NOR       | ~(A \| B)  |
| 1001   | XNOR      | ~(A ^ B)   |
| 1010   | NOT       | ~A         |
| 1011   | LSL       | A << 1     |
| 1100   | LSR       | A >> 1     |
| 1101   | ROL       | Rotate Left|
| 1110   | ROR       | Rotate Right|
| 1111   | PASS      | A          |

---

## 🚦 Flag Register

| Flag     | When is it SET (=1)?                          |
|----------|-----------------------------------------------|
| Zero     | Result is all zeros                           |
| Carry    | Unsigned overflow in ADD/SUB/INC/DEC          |
| Negative | MSB of result is 1 (result is negative)       |
| Overflow | Signed overflow in ADD or SUB                 |

---
## 💡 Key Concepts Demonstrated

| Concept | Where used |
|---------|-----------|
| **Modular RTL Design** | 4 sub-modules in hierarchy |
| **Combinational Logic** | always @(*) blocks |
| **Flag Generation** | Signed/unsigned overflow detection |
| **Port Mapping** | Sub-module instantiation |
| **Bit Concatenation** | 17-bit carry capture `{1'b0, A}` |
| **Ternary Operators** | Opcode decoding logic |
| **Self-checking TB** | Automated PASS/FAIL verification |

---
## 📚 What I Learned

- RTL Design and **Modular Architecture** in Verilog
- Difference between **Hardware and Software** execution
- **Flag generation logic** used in real CPU designs
- Writing **self-checking testbenches** with full coverage
- Using **Xilinx Vivado** for simulation, RTL analysis and synthesis
- **Signed vs Unsigned** arithmetic and overflow detection

---
## 👤 Author

**Chinmay Gawande**
- 🎓 College:BE in EnTC at SCOE,Pune
- 💼 Linkedin: https://www.linkedin.com/in/chinmay-gawande-201787326/
- 📧 Email:chinmaygawande@684gmail.com

---

