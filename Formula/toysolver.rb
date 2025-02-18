class Toysolver < Formula
  desc "Assorted decision procedures for SAT, SMT, Max-SAT, PB, MIP, etc."
  homepage "https://github.com/msakai/toysolver/"
  url "https://hackage.haskell.org/package/toysolver-0.9.0/toysolver-0.9.0.tar.gz"
  sha256 "398a8ee9b57bddac36dd5a31c8c774916f52959cc8f580a6082eecb52b4744a3"
  license "GPL-3.0-or-later"
  head "https://github.com/msakai/toysolver.git"

  bottle do
    root_url "https://ghcr.io/v2/msakai/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d16b6dec2784e431005fe00c68baea09f91a5145b3390fbe98e00b522347287a"
    sha256 cellar: :any_skip_relocation, ventura:       "e8cda6838481ff062cec66bcf5163b9f005e277d2b45a21ff01c193b09af0e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdf912ad93795b79dab9d56d00c0daa70eee813156d7c777e16f23284d8164d1"
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
