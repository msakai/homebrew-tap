class Liblbfgsb < Formula
  desc "Software for Large-scale Bound-constrained Optimization"
  # Use haskell-l-bfgs-b's homepage instead of the homepage of original L-BFGS-B.
  # because "brew audit" requires using HTTPS instead of HTTP for the original page,
  # but it failed to fetch from HTTPS on Linux due to SSL certificate problem.
  # homepage "https://users.iems.northwestern.edu/~nocedal/lbfgsb.html"
  homepage "https://nonempty.org/software/haskell-l-bfgs-b/"
  url "http://users.iems.northwestern.edu/~nocedal/Software/Lbfgsb.3.0.tar.gz"
  sha256 "f5b9a1c8c30ff6bcc8df9b5d5738145f4cbe4c7eadec629220e808dcf0e54720"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/msakai/homebrew-tap/releases/download/liblbfgsb-3.0"
    sha256 cellar: :any,                 ventura:      "dfbd3baafc7e2d356f5a0e27e5b6fdbd7cf6896ef1d915947733ac82f05b7880"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ea20496472cc2db0c3173a1ab3482a5ad1ef04b01c4ddb10c4b028a28c017466"
  end

  depends_on "gcc" # for gfortran
  depends_on "openblas"

  patch :p1 do
    url "http://nonempty.org/software/haskell-l-bfgs-b/silence.diff"
    sha256 "2d5cd46b869b569e72a6d81c45e17224603acf1840263cd394f7ed972f46a621"
  end

  patch :p1 do
    url "http://nonempty.org/software/haskell-l-bfgs-b/replace-linpack-with-lapack.diff"
    sha256 "1466cb7f79d233acfd882e0ed4bc75ecabd7d509a071c4997139505de068e2b2"
  end

  def install
    units = ["lbfgsb", "timer"]
    shared_lib = shared_library("liblbfgsb", 0)

    shared_option = if OS.mac?
      ["-o", shared_lib]
    else
      ["-Wl,-soname,#{shared_lib}", "-o", shared_lib]
    end
    system "gfortran", "-O2", "-shared", *shared_option, "-fPIC", *units.map { |name| "#{name}.f" },
           "-L#{Formula["openblas"].opt_lib}", "-lopenblas"

    units.each do |name|
      system "gfortran", "-O2", "-c", "#{name}.f"
    end
    system "ar", "cr", "liblbfgsb.a", *units.map { |name| "#{name}.o" }

    lib.install shared_lib, "liblbfgsb.a"
    lib.install_symlink shared_lib => shared_library("liblbfgsb")

    pkgshare.install "algorithm.pdf", "code.pdf",
                     "driver1.f", "driver1.f90", "driver2.f", "driver2.f90", "driver3.f", "driver3.f90"
  end

  test do
    system "gfortran", "-o", "x.lbfgsb_77_1", "-O2", pkgshare/"driver1.f", "-L#{lib}", "-llbfgsb"
    result = shell_output("./x.lbfgsb_77_1")
    assert_match(/CONVERGENCE: REL_REDUCTION_OF_F_<=_FACTR\*EPSMCH/, result)
  end
end