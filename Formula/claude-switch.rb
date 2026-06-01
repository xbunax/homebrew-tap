class ClaudeSwitch < Formula
  desc "TUI tool for switching Claude Code API backends"
  homepage "https://github.com/xbunax/claude-switch-tui"
  url "https://github.com/xbunax/claude-switch-tui/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "443be10b8061dd048838d783c538359c4d1d7b894b47828219714db2bfe88d30"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  def caveats
    <<~EOS
      Add shell integration to your rc file:
        #{opt_bin}/claude-switch --shell-init >> ~/.zshrc
      Then run `cs` to switch backends.
    EOS
  end

  test do
    system "#{bin}/claude-switch", "--version"
  end
end
