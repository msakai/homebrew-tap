class Opensmt2 < Formula
  desc "OpenSMT solver"
  homepage "https://github.com/usi-verification-and-security/opensmt"
  url "https://github.com/usi-verification-and-security/opensmt/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "a8a632e0853ec038f6d16c295f229a4d4d811a545288bc72efdbbd17dfd0b7d2"
  license "BSD-3-Clause"
  head "https://github.com/usi-verification-and-security/opensmt.git", branch: "master"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "gmp"

  uses_from_macos "libedit"

  def install
    system "make", "install", "INSTALL_DIR=#{prefix}", "CMAKE_FLAGS=-DENABLE_LINE_EDITING:BOOL=ON"
  end

  test do
    (testpath/"test.smt2").write <<~EOF
      (set-logic QF_AUFLIA)
      (declare-fun A () (Array Int Int))
      (declare-fun x () Int)
      (declare-fun y () Int)
      (declare-fun P () Bool)
      (declare-sort U 0)
      (declare-fun f (U) (Array Int Int))
      (declare-fun c () U)
      (assert
        (let ((fc (f c)))
          (and
            (=> (= A (store fc x 5)) (> (+ (select fc y) (* 4 x)) 0))
            (= P (< (select A (+ 3 y)) (* (- 2) x))))))
      (check-sat)
      (exit)
    EOF
    system bin/"opensmt", "test.smt2"
  end
end
