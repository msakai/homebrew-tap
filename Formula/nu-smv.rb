class NuSmv < Formula
  desc "Reimplementation and extension of SMV symbolic model checker"
  homepage "https://nusmv.fbk.eu"
  url "https://nusmv.fbk.eu/distrib/2.7.1/NuSMV-2.7.1.tar.xz"
  sha256 "f1e11931f71d98aa9b84181eed67db584d7111100c2e967c904a31c15f823f60"
  license "LGPL-2.1-or-later"

  keg_only "it conflicts with `minisat`"

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python" => :build
  depends_on "gmp"
  depends_on "libedit"
  depends_on "libxml2"

  deny_network_access!

  def install
    # build-doc requires doxigen and latexmk.
    system "meson", "setup", "build", *std_meson_args, "--wrap-mode=forcefallback", "-Dbuild-doc=disabled"
    # system "meson", "compile", "-C", "build", "doc", "--verbose"
    system "meson", "test", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.smv").write <<~EOS
      MODULE main
      SPEC TRUE = TRUE
    EOS

    output = shell_output("#{bin}/NuSMV test.smv")
    assert_match "specification TRUE = TRUE  is true", output
  end
end
