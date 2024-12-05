class Printemps < Formula
  desc "C++ metaheuristics modeler/solver for general integer optimization problems"
  homepage "https://snowberryfield.github.io/printemps/"
  url "https://github.com/snowberryfield/printemps/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "8653f4fa5ba26fc2e5ab7dd3e437004b971471fa7a8d4a1e86ddb61cdf78fd07"
  license "MIT"

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
    bin.install "build/application/Release/mps_solver.exe"

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
    system bin/"mps_solver.exe", "test.mps"
    h = JSON.parse(File.read("incumbent.json"))
    assert_equal h["objective"], -2.0

    gcc = Formula["gcc"]
    gcc_major_ver = gcc.any_installed_version.major
    cxx = gcc.opt_bin/"g++-#{gcc_major_ver}"
    system cxx, "-std=c++17", "-I#{include}", "-O3", pkgshare/"example"/"knapsack.cpp", "-o", "knapsack.exe"
    system "./knapsack.exe"
  end
end
