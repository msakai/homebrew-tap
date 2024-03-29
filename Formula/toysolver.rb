class Toysolver < Formula
  desc "Assorted decision procedures for SAT, SMT, Max-SAT, PB, MIP, etc."
  homepage "https://github.com/msakai/toysolver/"
  url "https://hackage.haskell.org/package/toysolver-0.8.1/toysolver-0.8.1.tar.gz"
  sha256 "aa7815204872ae243257262c55157155a6dffe4663d0219278640c8433e9c301"
  license "GPL-3.0-or-later"
  head "https://github.com/msakai/toysolver.git"

  bottle do
    root_url "https://github.com/msakai/homebrew-tap/releases/download/toysolver-0.8.1"
    sha256 cellar: :any_skip_relocation, ventura:      "e0e4dea32e6cf08d7d4158c05ba40edf8b1adb3f6b8b047df2aa87ea9e21931a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "43f1823f001a7db1ebf6cf3dd03da0098644300dbfab445d84a140d817a5b145"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-f", "BuildToyFMF", "-c", "optparse-applicative <0.18", *std_cabal_v2_args
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/toysat simple.cnf")
    assert_match(/s UNSATISFIABLE/, result)
  end
end
