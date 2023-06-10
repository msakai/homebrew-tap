class Toysolver < Formula
  desc "Assorted decision procedures for SAT, SMT, Max-SAT, PB, MIP, etc."
  homepage "https://github.com/msakai/toysolver/"
  url "https://hackage.haskell.org/package/toysolver-0.8.1/toysolver-0.8.1.tar.gz"
  sha256 "aa7815204872ae243257262c55157155a6dffe4663d0219278640c8433e9c301"
  license "GPL-3.0-or-later"
  head "https://github.com/msakai/toysolver.git"

  bottle do
    root_url "https://github.com/msakai/homebrew-tap/releases/download/toysolver-0.7.0"
    sha256 cellar: :any_skip_relocation, catalina:     "60b4da72b8ed82d34699dccb80de5f44c522b7d93033ec85dc6d3545419fc188"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "af8476df6088e75bdf1f10a4cb92fbb8fe859a9057936c6ab2f218cca87c48f7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

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
