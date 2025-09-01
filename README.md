
# ⚡ 128-Point FFT & Slicing Module for OFDM Receiver  

This project implements a **128-point complex FFT with a slicing stage** for a simplified OFDM (Orthogonal Frequency Division Multiplexing) receiver on FPGA. The design transforms time-domain I/Q input samples into frequency bins, applies energy-based slicing, and outputs quantized digital symbols.  

---

## 📘 System Overview  

- Accepts **128 complex samples** in **1.15 fixed-point format**  
- Performs a **128-point FFT**  
- Extracts energy from **24 active bins** (even-numbered bins 4–52)  
- Uses **reference tones** (bins 55 and 57) to approximate full-scale energy  
- Outputs **2-bit quantized symbols** per bin (total 48 bits per frame)  

---

## 🔧 Specifications  

| Feature            | Value/Description                              |
|---------------------|------------------------------------------------|
| **FFT length**      | 128-point, complex                             |
| **Input format**    | 16-bit signed fixed-point (1.15)               |
| **Active bins**     | Even-numbered bins 4–52 (24 total)             |
| **Reference bins**  | 55 and 57 (used for energy scaling)            |
| **Encoding**        | 2 bits per tone (00, 01, 10, 11)               |
| **Output width**    | 48 bits (24 tones × 2 bits)                    |
| **Clocking**        | Positive-edge triggered                        |
| **Reset**           | Asynchronous, active-high                      |

---

## 📤 Symbol Encoding  


Each bin's magnitude is compared against full scale derived from bin 55 or 57:

| Encoded Value | Energy Level | Magnitude Range (% of Full Scale) |
| ------------- | ------------ | --------------------------------- |
| 00            | 0%           | < 25%                             |
| 01            | 33%          | ≥25% and <50%                     |
| 10            | 66%          | ≥50% and <75%                     |
| 11            | 100%         | ≥75%                              |

---

## 🔄 Interface Ports  


| Name        | Dir | Width | Description                           |
| ----------- | --- | ----- | ------------------------------------- |
| `Clk`       | In  | 1     | Positive-edge system clock            |
| `Reset`     | In  | 1     | Active-high asynchronous reset        |
| `PushIn`    | In  | 1     | Indicates valid input data            |
| `FirstData` | In  | 1     | Marks the start of an FFT frame       |
| `DinR`      | In  | 16    | Real part of input (1.15 format)      |
| `DinI`      | In  | 16    | Imaginary part of input (1.15 format) |
| `PushOut`   | Out | 1     | Output valid indicator                |
| `DataOut`   | Out | 48    | 2-bit sliced outputs per FFT bin      |

---
--------------------
DUT REPORT
--------------------
dut0: ERROR
dut1: ERROR
dut2: PASS
dut3: PASS
dut4: PASS
dut5: PASS
dut6: ERROR
dut7: PASS
dut8: ERROR
dut9: ERROR
dut: PASS
