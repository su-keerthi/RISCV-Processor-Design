# RISCV 64-bit Processor Design

This project presents a two-phase implementation of a RISC-V 64-bit (RV64I) processor using Verilog. It demonstrates the transition from a simple single-cycle design to a pipelined architecture with hazard handling.


---

## Phase I: Sequential Processor

The initial design follows a single-cycle architecture, where each instruction completes all stages within one clock cycle.

### Main Features
- Simple control logic  
- Direct data paths between components  
- Unified Control Unit and ALU Control  
- All operations (fetch, decode, execute, memory access, write-back) occur within a single cycle:
Instruction Memory → Control Unit → Register File → ALU → Data Memory → Register File


However the clock speed is limited by the longest instruction path (typically load instructions), which restricts performance.

---

## Phase II: Pipelined Processor

The design is extended into a 5-stage pipelined architecture to improve throughput and allow higher clock frequencies.

### Pipeline Stages

1. IF (Instruction Fetch)  
   Fetches the instruction and updates the Program Counter  

2. ID (Instruction Decode)  
   Decodes the instruction, reads registers, and generates immediate values  

3. EX (Execute)  
   Performs ALU operations and computes branch targets  

4. MEM (Memory Access)  
   Handles load and store operations  

5. WB (Write Back)  
   Writes results back to the register file  

---

## Hazard Management

To ensure correct execution in the pipeline, the following mechanisms are implemented:

### Data Forwarding Unit
- Resolves RAW (Read-After-Write) hazards  
- Forwards results from EX/MEM and MEM/WB stages to the ALU inputs  
- Minimizes pipeline stalls  

### Hazard Detection Unit
- Detects load-use hazards  
- Introduces stalls by freezing the Program Counter and IF/ID register  

### Control Hazard Handling
- Uses pipeline flushing when a branch is taken  
- Inserts NOPs to maintain correct execution flow  

---

## Hardware Components

- 64-bit ALU  
  Supports arithmetic (ADD, SUB), logical (AND, OR), and comparison operations  

- Register File  
  32 general-purpose 64-bit registers with x0 hardwired to zero  

- Immediate Generator  
  Generates sign-extended immediates for I-type, S-type, and SB-type instructions  

- Pipeline Registers  
  IF/ID, ID/EX, EX/MEM, MEM/WB registers to maintain state between stages  

---

## Key Takeaways

- Single-cycle design is simple but limited in performance  
- Pipelining improves throughput significantly  
- Hazard handling is essential for correctness in pipelined processors  

---

## Future Improvements

- Dynamic branch prediction  
- Cache integration  
- Support for additional RISC-V instruction extensions  
