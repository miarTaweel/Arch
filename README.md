# 16-bit Multicycle RISC Processor in Verilog  

This project focuses on designing and implementing a **16-bit multicycle RISC processor** using **Verilog**. The processor is designed with a **datapath and control unit**, capable of executing a set of instructions efficiently. The implementation is verified through simulation to ensure correct functionality.  


## **Processor Specifications**  

✔ **16-bit Instruction & Word Size** – The processor operates with **16-bit** instructions and data words.  
✔ **8 General-Purpose Registers** – Each register is **16-bit**, allowing flexible integer computations.  
✔ **Separate Instruction & Data Memory** – Two dedicated physical memories enhance performance.  
✔ **Word-Addressable Memory** – Each memory access reads or writes a full **16-bit word**.  
✔ **Three Instruction Types Supported:**  
   - **R-Type (Register-Register Instructions)**  
   - **I-Type (Immediate Instructions)**  
   - **J-Type (Jump Instructions)**  
✔ **Performance Registers** – Includes additional registers to monitor execution metrics.  


## **Supported Instructions**  

The processor is capable of executing a variety of instructions:  

### ** R-Type (Register Instructions)**  
| Instruction | Operation | Description |
|------------|-----------|-------------|
| `AND Rd, Rs, Rt` | `Rd = Rs & Rt` | Bitwise AND |
| `ADD Rd, Rs, Rt` | `Rd = Rs + Rt` | Addition |
| `SUB Rd, Rs, Rt` | `Rd = Rs - Rt` | Subtraction |
| `SLL Rd, Rs, Rt` | `Rd = Rs << Rt` | Logical left shift |
| `SRL Rd, Rs, Rt` | `Rd = Rs >> Rt` | Logical right shift |

### ** I-Type (Immediate Instructions)**  
| Instruction | Operation | Description |
|------------|-----------|-------------|
| `ANDI Rt, Rs, Imm` | `Rt = Rs & Imm` | Bitwise AND with immediate |
| `ADDI Rt, Rs, Imm` | `Rt = Rs + Imm` | Addition with immediate |
| `LW Rt, Imm(Rs)` | `Rt = Mem[Rs + Imm]` | Load word from memory |
| `SW Rt, Imm(Rs)` | `Mem[Rs + Imm] = Rt` | Store word to memory |
| `BEQ Rs, Rt, Imm` | `if (Rs == Rt) PC += Imm` | Branch if equal |
| `BNE Rs, Rt, Imm` | `if (Rs != Rt) PC += Imm` | Branch if not equal |

### ** J-Type (Jump Instructions)**  
| Instruction | Operation | Description |
|------------|-----------|-------------|
| `FOR Rs, Rt` | Loop instruction | Custom looping functionality |
| `JMP Offset` | `PC = Offset` | Jump to address |
| `CALL Offset` | `Save PC; PC = Offset` | Function call |
| `RET` | `PC = Saved Address` | Return from function |


## **Implementation Details**  

- **Datapath:** Designed to handle arithmetic, logical, memory, and control operations.  
- **Control Unit:** Generates control signals for instruction execution over multiple cycles.  
- **Simulation:** The processor is tested using **testbenches** to validate execution correctness.  


## Contact

For any inquiries, reach out via:

- Email: [miar.taweel04@gmail.com](mailto\:miar.taweel04@gmail.com)
- GitHub: [miarTaweel](https://github.com/miarTaweel)

