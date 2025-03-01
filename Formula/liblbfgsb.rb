class Liblbfgsb < Formula
  desc "Software for Large-scale Bound-constrained Optimization"
  homepage "https://users.iems.northwestern.edu/~nocedal/lbfgsb.html"
  url "http://users.iems.northwestern.edu/~nocedal/Software/Lbfgsb.3.0.tar.gz"
  sha256 "f5b9a1c8c30ff6bcc8df9b5d5738145f4cbe4c7eadec629220e808dcf0e54720"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/msakai/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "77f87a48a7c57cdfe9e984695259899d86b06da34fe6a4689130ac95763a9d9a"
    sha256 cellar: :any,                 ventura:       "e6f994bfb6c5988851e75ac39fe8862dcd742bcf624249764631a51352450e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4ea836d6e218015fed4269eda0238199762eeb5b7bcd42066302b9dea5829a2"
  end

  depends_on "gcc" # for gfortran
  depends_on "openblas"

  patch :p1 do
    # url "http://nonempty.org/software/haskell-l-bfgs-b/silence.diff"
    url "https://raw.githubusercontent.com/msakai/haskell-l-bfgs-b/95ebf86c71a0edd6d1e203e747a1fff14f271b86/silence.diff"
    sha256 "2d5cd46b869b569e72a6d81c45e17224603acf1840263cd394f7ed972f46a621"
  end

  patch :p1 do
    # url "http://nonempty.org/software/haskell-l-bfgs-b/replace-linpack-with-lapack.diff"
    url "https://raw.githubusercontent.com/msakai/haskell-l-bfgs-b/95ebf86c71a0edd6d1e203e747a1fff14f271b86/replace-linpack-with-lapack.diff"
    sha256 "1466cb7f79d233acfd882e0ed4bc75ecabd7d509a071c4997139505de068e2b2"
  end

  def install
    units = ["lbfgsb", "timer"]
    shared_lib = shared_library("liblbfgsb", 0)

    shared_option = if OS.mac?
      ["-o", shared_lib]
    else
      File.write("liblbfgsb.map", <<-END)
      {
        global:
          extern "C" {
            setulb_;
          };

        local:
          *;
      };
      END
      ["-Wl,-soname,#{shared_lib}", "-Wl,--version-script,liblbfgsb.map", "-o", shared_lib]
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
