# RTL Design Verification Projects

This repository is used to practices using SystemVerilog and UVM (Universal Verification Methodology) to verify RTL design.

## 📁 Projects Included

### 1. APB-SPI Interconnect Verification

**Objective:**  
Verify the correct functionality of an APB-to-SPI bridge module, supporting bi-directional data transfers.

**Key Features:**
- **Outbound transfer**: From APB to SPI
- **Inbound transfer**: From SPI to APB
- **Functional Coverage:** 
  - `num_chars` field (number of characters per transfer) is a key coverage point
- **Verification Approach:**
  - Directed and constrained-random test sequences
  - Monitors and scoreboard to check data integrity
  - Coverage collection and analysis

### 2. Wishbone RAM Verification

**Objective:**  
Verify the correct read/write behavior of a RAM module interfaced via the Wishbone protocol.

**Key Features:**
- **Single Write & Read:** Write a value to a specific address and read it back
- **Block Write & Read:** Write a sequence of data to multiple addresses and read them back in order
- **Functional Coverage:**
  - Coverage on address space access patterns
- **Verification Approach:**
  - Scoreboard comparison for expected vs actual memory values
  - Random and directed scenarios

## 🛠️ Tools & Methodology

- **Language:** SystemVerilog
- **Methodology:** UVM (Universal Verification Methodology)
- **Simulator:** Mentor QuestaSim
- **Testbench Components:**
  - Agents (drivers, monitors)
  - Sequencer and sequence libraries
  - Scoreboard for checking correctness
  - Coverage models for key metrics
