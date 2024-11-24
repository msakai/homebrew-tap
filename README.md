# msakai/tap

This repository provides custom [Homebrew](https://brew.sh/) Tap for some of my works.

## List of formulae

* [toysolver](Formula/toysolver.rb) - Solvers for SAT, SMT, Max-SAT, PB, MIP, etc. developed by me. ([Github](https://github.com/msakai/toysolver), [Hackage](https://hackage.haskell.org/package/toysolver))
* [liblbfgsb](Formula/liblbfgsb.rb) - [L-BFGS-B](https://users.iems.northwestern.edu/~nocedal/lbfgsb.html) library for large-scale bound-constrained optimization, packaged by me for convinience of use Haskell's [l-bfgs-b](http://nonempty.org/software/haskell-l-bfgs-b) pacakge ([Hackage](https://hackage.haskell.org/package/l-bfgs-b)).
* [mingw-w64-dwarf2](Formula/mingw-w64-dwarf2.rb) - Minimalist GNU for Windows and GCC cross-compilers
  * This differs from the `mingw-w64` formula in that it uses `DWARF` instead of `SJLJ` for exceptions on i686. I created the formula for the compatibility with `mingw-w64-gcc` package of `MSYS`.

## How do I install these formulae?
`brew install msakai/tap/<formula>`

Or `brew tap msakai/tap` and then `brew install <formula>`.

## Documentation
`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
