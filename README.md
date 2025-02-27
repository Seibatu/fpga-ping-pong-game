# FPGA Ping-Pong Game 🎮🔴

This project implements a **digital ping-pong game** on an **FPGA (Nexys4 DDR Board)** using **Finite State Machines (FSMs)**, button synchronization, and a light pattern generator to simulate the movement of a ball across LEDs.

---

## 🎯 Overview

This project is designed to help understand **sequential logic design** by implementing **synchronized button control** and **light pattern generation** using FSMs. The game consists of a moving LED "ball" that players must "hit" using a button at the correct moment.

The **goal of the game** is to keep the ball bouncing back and forth between the starting position and the wall by pressing the **Play** button at the correct time. If the timing is incorrect, all LEDs flash to indicate game over.

---

## Features

✅ **Light Pattern Generator FSM**: Moves a single LED "ball" across a row of LEDs.
✅ **Button Synchronizer FSM**: Ensures button presses are registered correctly without glitches.
✅ **Clock Divider**: Reduces the FPGA’s 100 MHz clock to a lower frequency 2Hz for LED visibility.
✅ **Game Mechanics**:
  - `Begin` button starts the game.
  - `Play` button must be pressed when the ball reaches its start position (LD3) to "hit" it back.
  - `Reset` button resets the game to the initial state.

---

## ⚙️ How It Works

1. **Startup**: The game starts when the `Begin` button is pressed.
2. **Ball Movement**:
   - The LED ball moves from **LD3 → LD0**.
   - When the ball reaches **LD0 (wall)**, it automatically reverses.
   - When the ball reaches **LD3**, the player must press `Play` at the right moment to hit it back.
3. **Game Over Condition**:
   - If `Play` is not pressed in time at **LD3**, the game ends, and all LEDs flash.
4. **Reset**: The `Reset` button restarts the game.

---

## 🛠 Implementation Details

### **1️⃣ Button Synchronizer FSM**
- Ensures that button presses are properly detected.
- Converts any button press into a **single-cycle pulse**.

### **2️⃣ Light Pattern Generator FSM**
- Controls the LED sequence to simulate ball movement.
- Moves the LED left and right across **LD3 to LD0**.

### **3️⃣ Clock Divider**
- The FPGA operates at **100 MHz**, but LED movement needs to be visible.
- The clock divider reduces this to **2 Hz** for clear LED transitions.

---

## ▶️ How to Run
### 1️⃣ Simulation
To verify the design before FPGA implementation:
- **Testbenches** are used to verify:
  - FSM transitions
  - Button synchronization
  - LED movement pattern

- **Waveform analysis** can be found under **the Simulation Waveform** section 
  - FSM states
  - Button press effects
  - LED transitions

### 2️⃣ FPGA Implementation
### **On Vivado (Xilinx FPGA)**
1. Open Vivado and create a new project.
2. Add all Verilog source files.
3. Apply `constraints.xdc` for **pin mapping**.
4. Synthesize, implement, and generate the bitstream.
5. Program the Nexys4 DDR board.
6. Play the game using the **Begin, Play, and Reset** buttons.

---

## 📂 Repository Structure

```
📁 src/
  │── 📄 binaryBCD.v             # Binary to BCD converter
  │── 📄 btn2HzSynch.v           # 2Hz Button Synchronizer
  │── 📄 btnSynchDebounce.v      # Debounced Button Synchronizer
  │── 📄 clkDivider.v            # Clock Divider (100MHz → 2Hz)
  │── 📄 fsmGameCtrl.v           # FSM Controller for Ping-Pong Game
  │── 📄 sevenSegment.v          # 7-segment display driver (if used)
  │── 📄 topModule.v             # Top-level module integrating all components
  │── 📄 constraints.xdc         # Nexys4 DDR constraints file (pin mapping)
```
---

## 📸 Simulation Waveform

---

## ✉️ Contact
For any questions or improvements or collaborations, feel free to connect:
- **GitHub:** [Seibatu](https://github.com/Seibatu)
- **LinkedIn:** [Seiba Abdul Rahman](https://www.linkedin.com/in/seiba-abdul-rahman)
