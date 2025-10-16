class ScipDev < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://github.com/scipopt/scip.git",
      revision: "b9cbe65ddcc59436e729cc3cf3c1cbb67567c79f"
  version "10.0.0"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cppad"
  depends_on "gmp"
  depends_on "ipopt"
  depends_on "openblas"
  depends_on "papilo"
  depends_on "readline"
  depends_on "soplex"
  depends_on "tbb"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DZIMPL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "check/instances/MIP/enigma.mps"
    pkgshare.install "check/instances/MINLP/gastrans.nl"
  end

  test do
    assert_match "problem is solved [optimal solution found]", shell_output("#{bin}/scip -f #{pkgshare}/enigma.mps")
    assert_match "problem is solved [optimal solution found]", shell_output("#{bin}/scip -f #{pkgshare}/gastrans.nl")
  end
end
