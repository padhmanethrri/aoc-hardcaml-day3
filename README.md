# Advent of FPGA Challenge — Day 3 (Hardcaml)

This repository contains my solutions for **Day 3 of the Advent of FPGA Challenge**,
implemented using **Hardcaml**, an OCaml-based hardware description language.

The focus of this work is to explore how problems that are typically solved using
string processing and sequential software logic can be re-expressed as
**hardware-oriented designs** with explicit state, clocked behavior, and
cycle-accurate execution.

## Motivation

Day 3 introduces more complex control and state handling compared to earlier days,
making it a good candidate for exploring how non-trivial logic can be modeled as
hardware.

Rather than treating the problem as a purely software algorithm, the goal here was to:
- model the computation using explicit registers and signals
- process inputs incrementally in a streaming fashion
- reason about correctness and behavior at the RTL level

Hardcaml was chosen because it allows hardware designs to be written in a structured
and compositional way while staying close to synthesizable RTL concepts.

## Repository Structure

The repository is organized by problem part, following the Advent of FPGA format.

Each part contains:
- a Hardcaml design file describing the hardware behavior
- a testbench that drives the design and handles input/output
- the puzzle input used for validation
- a README explaining the approach and design decisions

Current structure:

advent-of-fpga-day3/
- part1/
  - day3_part1.ml
  - test.ml
  - input.txt
  - dune
  - README.md
- part2/
  - day3_part2.ml
  - test_part2.ml
  - input.txt
  - dune
  - README.md

The design and testbench are intentionally separated to reflect standard hardware
development practices.

## Current Status

Day 3:
- Part 1 completed and validated
- Part 2 completed and validated
- Both parts simulated using cycle-accurate Hardcaml testbenches
- Full puzzle inputs used for verification

## How to Run

Each part includes a testbench that:
- reads the puzzle input from `input.txt`
- drives the design cycle by cycle
- prints the final result after simulation completes

Simulations are run using `dune` and the Hardcaml library.

No FPGA synthesis or physical implementation is required for this challenge, though
the designs are written to remain synthesizable.

## Design Principles

Across both parts, the designs emphasize:

- Explicit state modeling  
  All state is represented using registers with clear clocked updates.

- Streaming computation  
  Inputs are processed incrementally rather than buffered and processed in bulk.

- Hardware-oriented structure  
  The logic is expressed in terms of signals and state transitions rather than
  software-style loops.

- Clarity and correctness  
  The focus is on designs that are easy to reason about at the RTL level and validate
  through simulation.

## Notes

This repository represents an exploration of hardware thinking applied to algorithmic
problems. The intent is not aggressive optimization, but clear and correct modeling of
behavior in a way that reflects how real hardware operates.

All code in this repository represents original work and can be explained and reasoned
about directly at the RTL level.
