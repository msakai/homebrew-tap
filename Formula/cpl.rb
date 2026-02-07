class Cpl < Formula
  desc "Interpreter of Hagino's Categorical Programming Language (CPL)"
  homepage "https://github.com/msakai/cpl/"
  url "https://hackage.haskell.org/package/CPL-0.2.0/CPL-0.2.0.tar.gz"
  sha256 "5473ddebcd4266b15c497e5693d5628cce1e4ae666fad8c7055708d1e1af979b"
  license "GPL-3.0-or-later"
  head "https://github.com/msakai/cpl.git", branch: "master"

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "ncurses"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"examples.cpl").write <<~EOS
      right object 1 with !
      end object;

      right object prod(a,b) with pair is
        pi1: prod -> a
        pi2: prod -> b
      end object;

      right object exp(a,b) with curry is
        eval: prod(exp,a) -> b
      end object;

      left object nat with pr is
        0: 1 -> nat
        s: nat -> nat
      end object;

      left object coprod(a,b) with case is
        in1: a -> coprod
        in2: b -> coprod
      end object;

      show pair(pi2,eval);

      let add=eval.prod(pr(curry(pi2), curry(s.eval)), I);

      simp add.pair(s.s.0, s.0);

      let mult=eval.prod(pr(curry(0.!), curry(add.pair(eval, pi2))), I);

      let fact=pi1.pr(pair(s.0,0), pair(mult.pair(s.pi2,pi1), s.pi2));

      simp fact.s.s.s.s.0;
    EOS

    result = shell_output("#{bin}/cpl examples.cpl")
    assert_match("s.s.s.s.s.s.s.s.s.s.s.s.s.s.s.s.s.s.s.s.s.s.s.s.0", result)
  end
end
