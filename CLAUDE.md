# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A custom Homebrew tap (`msakai/tap`) containing formula definitions for mathematical optimization solvers and related tools. All formulae are Ruby files in `Formula/`.

## Useful Commands

```bash
# Lint a formula for errors and style
brew audit --strict --online <name>

# Check formula style only
brew style Formula/<name>.rb

# Install a formula from source (local)
brew install --build-from-source Formula/<name>.rb

# Run a formula's test block
brew test <name>
```

## Formulae Overview

- **toysolver** — Haskell-based SAT/SMT/Max-SAT/PB/MIP solvers; built with `cabal`
- **liblbfgsb** — Fortran L-BFGS-B optimization library; custom build with `gfortran`, produces both shared and static libs
- **printemps** — C++ metaheuristics solver; uses `cmake` via `make` wrapper, requires GCC for OpenMP
- **mingw-w64-dwarf2** — MinGW-w64 cross-compiler targeting i686 with DWARF2 exceptions (differs from upstream `mingw-w64` which uses SJLJ); multi-stage bootstrap build (binutils → headers → gcc stage1 → crt → winpthreads → gcc full)
- **scip-dev** — SCIP mixed integer programming solver; built from a specific git revision of the v10-minor branch using `cmake`

## Conventions

- Bottles are hosted on GHCR at `ghcr.io/v2/msakai/tap`
- Formulae follow standard Homebrew formula conventions (class name is PascalCase of the formula filename)
- Platform-specific logic uses `OS.mac?`, `OS.linux?`, `Hardware::CPU.arm?`
- Build dependencies are marked with `=> :build`; macOS system libraries use `uses_from_macos`
