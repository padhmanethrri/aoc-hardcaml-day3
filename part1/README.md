# Day 3 – Part 1 (Hardcaml)

This directory contains my solution for Day 3, Part 1 of the Advent of FPGA Challenge,
implemented using Hardcaml.

The problem involves computing the maximum possible joltage produced by each bank of
batteries and summing these values across all banks. Each bank is processed
independently, making it well suited for a hardware-oriented, streaming approach.

## Problem Summary

Each line of the input represents a bank of batteries, where each digit corresponds
to a battery’s joltage rating (from 1 to 9).

Within each bank:
- Exactly two batteries must be selected
- The order of batteries cannot be changed
- The joltage produced by a bank is the two selected digits interpreted as a number

The goal is to:
- Find the **maximum possible joltage per bank**
- Compute the **sum of these maximum values** across all banks

For example:
- `987654321111111` → 98  
- `811111111111119` → 89  
- `234234234234278` → 78  
- `818181911112111` → 92  

The final output is the sum of the maximum joltage from each bank.

## File Overview

- `day3_part1.ml`  
  Contains the core hardware design written using Hardcaml. This module describes the
  computation using explicit registers, combinational logic, and clocked updates. The
  design models how each bank is processed sequentially while maintaining the necessary
  state to compute the maximum two-digit joltage.

- `test.ml`  
  Acts as the testbench. It reads the puzzle input from `input.txt`, feeds each bank
  into the design cycle by cycle, runs the simulation, and prints the final accumulated
  result.

- `input.txt`  
  Contains the full puzzle input used to validate the implementation.

- `dune`  
  Build configuration used to compile and run the design and testbench.

## Design Approach

The problem was first analyzed to identify the minimal state required to compute the
maximum two-digit value from a sequence of digits. Rather than buffering an entire
bank or performing software-style scans, the logic was mapped into a hardware-style
streaming computation.

Each digit is processed sequentially, and the design maintains registers to track the
best candidate digits seen so far. At each step, combinational logic determines whether
the current digit contributes to a higher possible joltage than the previously stored
state.

This allows the design to compute the correct maximum value using a single pass over
each bank.

## Hardware Architecture

- Explicit registers are used to model intermediate state
- All updates occur on clock edges
- Combinational logic is used to compare and select candidate digits
- No dynamic memory or large buffers are required

Each bank is handled independently, and the accumulated total is updated once the
maximum joltage for a bank has been determined.

## Scalability

The design does not depend on the length of a battery bank.

As a result:
- Banks with more digits require no RTL changes
- Larger inputs simply require more clock cycles
- The same architecture works for small examples and full puzzle input

This makes the design suitable for large datasets and streaming input sources.

## Testing and Verification

Verification is performed using `test.ml`, which:
- Reads each bank from `input.txt`
- Drives the design cycle by cycle
- Accumulates the per-bank maximum joltage values
- Prints the final result after simulation completes

The design was validated using the full puzzle input.

## Result

When simulated with the provided input, the design produced the following result:

**Total Output Joltage: 17435**

This matches the expected answer for Day 3, Part 1.

## Summary

This implementation demonstrates how a problem that appears sequential in software
can be expressed cleanly as a hardware-oriented design using explicit state and
streaming computation.

By modeling the logic at the RTL level with Hardcaml, the solution emphasizes clarity,
scalability, and cycle-accurate behavior while remaining fully synthesizable.

