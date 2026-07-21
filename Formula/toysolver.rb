class Toysolver < Formula
  desc "Assorted decision procedures for SAT, SMT, Max-SAT, PB, MIP, etc."
  homepage "https://github.com/msakai/toysolver/"
  url "https://hackage.haskell.org/package/toysolver-0.10.0/toysolver-0.10.0.tar.gz"
  sha256 "27265a4a8666bc62adf587544cb42ef0fc68360f929bf3f6932ace77eb961d21"
  license "GPL-3.0-or-later"
  head "https://github.com/msakai/toysolver.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/msakai/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "44fb26fadf8a9f2ed0a737f9be4eb09c8c02c9d0e534d508771edeef24a7869a"
    sha256 cellar: :any,                 x86_64_linux: "b51af2122cb339c2d6751058512d1c343869170387a2e3540c407664804c1f08"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-f", "BuildToyFMF", *std_cabal_v2_args
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
