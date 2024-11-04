# LED Brightness in VHDL 

This project implements LED brightness control using Pulse Width Modulation (PWM) on the DE-10 Nano FPGA board. The design is written in VHDL and includes a top-level module, `LED_BRIGHTNESS`, which coordinates two main sub-modules: `PWM` and `COUNTER`. Together, they enable smooth brightness transitions for LEDs by adjusting the duty cycle of a PWM signal.

---

## Project Structure

### Top-Level Module: `LED_BRIGHTNESS`
- The top-level module `LED_BRIGHTNESS` manages the PWM and Counter sub-modules to adjust the brightness of LEDs.
- Interfaces directly with the DE-10 Nano's LEDs, adjusting brightness based on the duty cycle set by the PWM component.

### Sub-Modules
1. **PWM (Pulse Width Modulation)**  
   - Generates a PWM signal with a variable duty cycle to control LED brightness.
   - The duty cycle can be adjusted to increase or decrease brightness. A higher duty cycle results in a brighter LED.
   - Frequency and bit depth are configurable, allowing for control over both standard LEDs and RGB LEDs.
  
2. **COUNTER**
   - Provides timing and frequency division, setting the duration of brightness changes.
   - Counts up to a specified maximum value (`LED_MAX_COUNT`), after which it resets, incrementing the PWM duty cycle for gradual brightness control.

### For DE-10 Nano FPGA board 

- `Led_Brightness_Pinout.csv` file has the board pinout for assignment  
---

## Features

- **Smooth Brightness Control**: Adjusts brightness by incrementing the PWM duty cycle, providing a gradual transition from low to high brightness.
- **Configurable Parameters**:
  - `INPUT_CLK`: Sets the input clock frequency (default is 25 MHz).
  - `NUM_LEDS`: Defines the number of LEDs controlled by the module.
  - `MAX_LED_DUTY`: Sets the maximum PWM duty cycle, corresponding to full brightness.
- **Supports Multiple LEDs**: Configurable to control the brightness of several LEDs at once with a synchronized PWM signal.

---

## Usage

- This module can be integrated into larger projects requiring LED brightness control or applied to projects involving PWM-based control (e.g., motor control).
- Modify `LED_MAX_COUNT` and `MAX_LED_DUTY` to customize the speed and range of brightness changes.


