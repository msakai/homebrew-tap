class Printemps < Formula
  desc "C++ metaheuristics modeler/solver for general integer optimization problems"
  homepage "https://snowberryfield.github.io/printemps/"
  url "https://github.com/snowberryfield/printemps/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "f9ca2d0176ae5bc1b3deffe1f7318b3a568ec9512be208d54367747e37f9550c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/msakai/tap"
    sha256 cellar: :any,                 arm64_tahoe:  "dbc4cff6d19c702e436b345bcf58a7585a9326f110989c94d614870a533a4214"
    sha256 cellar: :any,                 sequoia:      "c6ff9ea21da2848a9e6cd48613f8520edc496e6da7cf0b12f7436d9a8395412a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5b5d406135622be0e3213caa6ad63ea09f633d5328d2516cb98372c3cf457f37"
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
      cpu_arch = "apple-m1"
    elsif build.bottle?
      cpu_arch = Hardware.oldest_cpu
    end

    system "make", "application", "extra", "CC=#{cc}", "CXX=#{cxx}", "CPU_ARCH=#{cpu_arch}"
    bin.install "build/application/Release/printemps"
    libexec.install "build/extra/Release/maxsat_evaluation_solver"
    libexec.install "build/extra/Release/pb_competition_solver"

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
    system bin/"printemps", "test.mps"
    h = JSON.parse(File.read("incumbent.json"))
    assert_equal h["objective"], -2.0

    gcc = Formula["gcc"]
    gcc_major_ver = gcc.any_installed_version.major
    cxx = gcc.opt_bin/"g++-#{gcc_major_ver}"
    system cxx, "-std=c++17", "-I#{include}", "-O3", pkgshare/"example"/"knapsack.cpp", "-o", "knapsack"
    system "./knapsack"
  end
end
