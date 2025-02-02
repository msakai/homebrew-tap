class Printemps < Formula
  desc "C++ metaheuristics modeler/solver for general integer optimization problems"
  homepage "https://snowberryfield.github.io/printemps/"
  url "https://github.com/snowberryfield/printemps/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "cadd78180e222ded82a36ce612d466122634ddfd77166b00825094de106f8014"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/msakai/tap"
    sha256 cellar: :any,                 arm64_sequoia: "64c46eb5c2a09d8ac46b98c873eb35af72cdef5951e46bff219364d2366d4806"
    sha256 cellar: :any,                 ventura:       "c72b41cb0f0e369179b81b2ed72396608981d7fd0dfe5bd2d6c34dade0a27ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aab79d2a8dd92289bd7c32307b9a63b0f38065912640adf802a6b75de08a7db0"
  end

  depends_on "cmake" => :build
  # We use gcc because cmake fails to find OpenMP with Apple clang
  depends_on "gcc"

  def install
    gcc = Formula["gcc"]
    gcc_major_ver = gcc.any_installed_version.major
    cc = gcc.opt_bin/"gcc-#{gcc_major_ver}"
    cxx = gcc.opt_bin/"g++-#{gcc_major_ver}"

    if Hardware::CPU.arm? && OS.mac?
      inreplace "cmake/application/CMakeLists.txt", "-march=native", "-mcpu=apple-m1"
    elsif build.bottle?
      inreplace "cmake/application/CMakeLists.txt", "-march=native", "-march=#{Hardware.oldest_cpu}"
    end

    system "make", "-f", "makefile/Makefile.application", "CC=#{cc}", "CXX=#{cxx}"
    bin.install "build/application/Release/mps_solver"

    include.install Dir["printemps/*"]
    pkgshare.install "example"
    doc.install "README.md"
    doc.install "LICENSE"
  end

  test do
    # Example from https://en.wikipedia.org/wiki/Integer_programming
    (testpath/"test.mps").write <<~EOF
      NAME          test
      ROWS
       N  obj1
       L  row1
       L  row2
       L  row3
      COLUMNS
          MARK0000  'MARKER'                 'INTORG'
          x         row1      -1.0
          x         row2      3.0
          x         row3      2.0
          y         obj1      -1.0
          y         row1      1.0
          y         row2      2.0
          y         row3      3.0
          MARK0001  'MARKER'                 'INTEND'
      RHS
          rhs       row1      1.0
          rhs       row2      12.0
          rhs       row3      12.0
      BOUNDS
       LI bound     x         0.0
       PL bound     x
       LI bound     y         0.0
       PL bound     y
      ENDATA
    EOF
    system bin/"mps_solver", "test.mps"
    h = JSON.parse(File.read("incumbent.json"))
    assert_equal h["objective"], -2.0

    gcc = Formula["gcc"]
    gcc_major_ver = gcc.any_installed_version.major
    cxx = gcc.opt_bin/"g++-#{gcc_major_ver}"
    system cxx, "-std=c++17", "-I#{include}", "-O3", pkgshare/"example"/"knapsack.cpp", "-o", "knapsack"
    system "./knapsack"
  end
end
