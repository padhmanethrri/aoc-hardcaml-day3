# Day 3 – Part 2 (Hardcaml)

This directory contains my solution for Day 3, Part 2 of the Advent of FPGA Challenge,
implemented using Hardcaml and OCaml.

The submission includes fully open-sourced RTL, a cycle-accurate testbench, and
detailed documentation explaining the algorithmic and architectural decisions.

---

## What Is Included

This submission provides:
- Fully open-source **hardware design (RTL)** written in Hardcaml
- A **cycle-accurate testbench** for simulation and verification
- A **README** describing the algorithm, architecture, scalability, and trade-offs
- A reproducible build and run flow using `dune`

---

## Problem Summary

Each line of the input represents a bank of batteries, where each digit corresponds
to a battery’s joltage rating (from 1 to 9).

Within each bank:
- Exactly twelve batteries must be selected
- The relative order of digits must be preserved
- The selected digits form a 12-digit number

The objective is to:
- Compute the maximum possible 12-digit joltage per bank
- Sum these values across all banks

---

## High-Level Architecture

The solution is deliberately split into two stages:

1. **Greedy digit selection (OCaml)**
2. **Streaming numeric accumulation (Hardcaml RTL)**

This separation allows algorithmic complexity to be resolved once, while the hardware
remains simple, fast, and scalable.

---

## Algorithmic Approach (Greedy Selection)

Selecting the maximum possible 12-digit number while preserving digit order exhibits
optimal substructure and admits a provably correct greedy solution.

Key observations:
- If a larger digit appears later, removing a smaller preceding digit always improves
  the final number (as long as enough digits remain).
- Once a digit is removed, it never needs to be reconsidered.

A single-pass, stack-based greedy algorithm is therefore sufficient:
- Digits are processed left-to-right
- Smaller digits are dropped when a larger digit appears and dropping is allowed
- Exactly twelve digits remain at the end

This algorithm runs in linear time and guarantees the optimal result.

OCaml is used to express this logic clearly and deterministically, closely mirroring
the correctness argument without introducing stateful complexity into the hardware.

---

## Hardware Design (Hardcaml RTL)

After greedy selection, the hardware receives a fixed-size, ordered stream of digits
and performs a purely streaming computation.

### Core behavior:
- Digits are consumed sequentially
- An accumulator register constructs the number:
  `acc = acc * 10 + digit`
- At the end of each bank, the accumulated value is added to a running sum

### Architectural properties:
- Explicit clocked registers
- Combinational arithmetic
- No buffering of entire banks
- Fully synthesizable RTL

This models how a real accelerator would operate when fed a preprocessed data stream.

---

## Scalability

The design scales cleanly to much larger inputs:

- **10× or 1000× larger inputs** require no RTL changes
- Input size affects only the number of cycles, not the hardware area
- No internal buffers grow with input length

Both the greedy preprocessing and the hardware design operate in linear time with
constant hardware resources per digit.

---

## Efficiency and Trade-Offs

The design explicitly trades control complexity for simplicity and throughput:

- Avoids large memories or combinational selection networks
- Uses a single accumulator datapath
- Minimizes control logic and state

This results in:
- Small area footprint
- Predictable timing
- High suitability for pipelining or replication if higher throughput is required

---

## FPGA-Oriented Architecture

The design exploits FPGA-friendly characteristics:
- Streaming dataflow
- Simple arithmetic pipelines
- Independent per-bank processing
- Clear separation of control and datapath

Multiple instances of the accumulator can be instantiated in parallel to process
multiple banks concurrently, a form of parallelism not easily achievable on a CPU.

---

## Physical Synthesis Readiness

The RTL:
- Uses only synthesizable constructs
- Avoids dynamic memory and unbounded structures
- Is suitable for FPGA synthesis and small ASIC flows

The design can be targeted to open-source ASIC flows (e.g., TinyTapeout-style flows)
without modification, making it suitable for physical synthesis experimentation.

---

## File Overview

- `day3_part2.ml`  
  Hardcaml hardware description implementing the accumulator and summation logic.

- `test.ml`  
  Cycle-accurate simulation harness. Reads input, applies greedy selection, streams
  digits into the design, and prints the final result.

- `input.txt`  
  Full puzzle input.

- `dune`  
  Build configuration.

---

## How to Run

```bash
dune exec ./bin/test.exe
