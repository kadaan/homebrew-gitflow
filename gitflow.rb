class Gitflow < Formula
  desc "AVH edition of git-flow"
  homepage "https://github.com/kadaan/gitflow-avh"

  stable do
    url "https://github.com/kadaan/gitflow-avh/archive/1.12.2-di.tar.gz"
    sha256 "c849811f3234dc776f8468c08a9f9653b539bb7f90393a4bf96cd9b382ac12d4"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion/archive/0.6.0.tar.gz"
      sha256 "b1b78b785aa2c06f81cc29fcf03a7dfc451ad482de67ca0d89cdb0f941f5594b"
    end
  end

  head do
    url "https://github.com/kadaan/gitflow-avh.git", :branch => "develop"

    resource "completion" do
      url "https://github.com/kadaan/git-flow-completion.git", :branch => "develop"
    end
  end

  depends_on "gnu-getopt"

  conflicts_with "git-flow", :because => "Both install `git-flow` binaries and completions"

  def install
    system "make", "prefix=#{libexec}", "install"
    (bin/"git-flow").write <<~EOS
      #!/bin/bash
      export FLAGS_GETOPT_CMD=#{Formula["gnu-getopt"].opt_bin}/getopt
      exec "#{libexec}/bin/git-flow" "$@"
    EOS

    resource("completion").stage do
      bash_completion.install "git-flow-completion.bash"
      zsh_completion.install "git-flow-completion.zsh"
      fish_completion.install "git.fish"
    end
  end

  test do
    system "git", "init"
    system "#{bin}/git-flow", "init", "-d"
    system "#{bin}/git-flow", "config"
    assert_equal "develop", shell_output("git symbolic-ref --short HEAD").chomp
  end
end
