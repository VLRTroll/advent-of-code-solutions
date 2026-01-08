# Avent of Code 2025 - Zig

A collection of Advent of Code solutions implemented in Zig. Each day's solution lives in its own folder (e.g. `day_1/`).

**Zig version:** 0.15.2

**Documentation:** https://ziglang.org/documentation/0.15.2

# Progress

| Day | Part 1 | Part 2 |
|-----:|:------:|:------|
| 1 | <span style="color: yellow;">*</span> | <span style="color: yellow;">*</span> |
| 2 | | |
| 3 | | |
| 4 | | |
| 5 | | |
| 6 | | |
| 7 | | |
| 8 | | |
| 9 | | |
| 10 | | |
| 11 | | |
| 12 | | |


# How to Use it

- **Prerequisites:** Install Zig 0.15.2. On Windows you can download the binary from the official Zig releases and add it to your PATH.

- **Run a solution:** to compile and run a day's solution use `zig run` from the project root. Example for day 1:

```powershell
zig run main.zig
```

- **Run tests:** many days include a test file. Run a day's tests with `zig test` **inside the day folder**:

```powershell
zig test 2025_01.test.zig
```

- **Inputs:** example inputs are stored inside each day's folder as `input.txt`.

**Repository layout**

- `main.zig` — optional runner / entry point
- `solutions_registry.zig` — registry of available solutions
- `day_<n>/` — folder per day containing solution, tests and `input.txt`

## Execution sample

**Asking for a registered solution**

```text
[Avent of Code 2025]

Select a day: (1~12) 1
Input's file path: (day_1/input.txt)

[Day 1]
 * Part 1: 3
 * Part 2: 6
```

**Asking for a non registered solution**

```text
[Avent of Code 2025]

Select a day: (1~12) 25
Input's file path: (day_25/input.txt) 

** No solutions found for Day 25 **
```

# Links to learn more about Zig

- [Learn Zig in Y Minutes](https://learnxinyminutes.com/zig/)

- [Standart Lib Reference](https://ziglang.org/documentation/0.15.2/std/#)

- [Zig Guide (Community)](https://zig.guide)

- [Ziggit (Blog)](https://ziggit.dev)

- [Zig Master (Youtube Playlist)](https://www.youtube.com/playlist?list=PLtB7CL7EG7pDKdSBA_AlNYrEsISOHBOQL)