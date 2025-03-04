# msakai/tap

This repository provides custom [Homebrew](https://brew.sh/) Tap for software that I have developed or that I have packaged.

## List of formulae

* [toysolver](Formula/toysolver.rb) - Solvers for SAT, SMT, Max-SAT, PB, MIP, etc. developed by me. ([Github](https://github.com/msakai/toysolver), [Hackage](https://hackage.haskell.org/package/toysolver))
* [liblbfgsb](Formula/liblbfgsb.rb) - [L-BFGS-B](https://users.iems.northwestern.edu/~nocedal/lbfgsb.html) library for large-scale bound-constrained optimization, packaged by me to make Haskell's [l-bfgs-b](http://nonempty.org/software/haskell-l-bfgs-b) package ([Hackage](https://hackage.haskell.org/package/l-bfgs-b)) easier to use.
* [mingw-w64-dwarf2](Formula/mingw-w64-dwarf2.rb) - Minimalist GNU for Windows and GCC cross-compilers
  * This differs from the `mingw-w64` formula in that it uses `DWARF` instead of `SJLJ` for exceptions on i686. I created the formula for the compatibility with `mingw-w64-gcc` package of `MSYS`.
* [printemps](Formula/printemps.rb) - C++ metaheuristics modeler/solver for general integer optimization problems ([Website](https://snowberryfield.github.io/printemps/), [GitHub](https://github.com/snowberryfield/printemps))

## How do I install these formulae?
`brew install msakai/tap/<formula>`

Or `brew tap msakai/tap` and then `brew install <formula>`.

## Documentation
`brew help`, `man brew`, or check [Homebrew's documentation](https://docs.brew.sh).
