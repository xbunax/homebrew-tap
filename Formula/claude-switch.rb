class ClaudeSwitch < Formula
  desc "TUI tool for switching Claude Code API backends"
  homepage "https://github.com/xbunax/claude-switch-tui"
  url "https://github.com/xbunax/claude-switch-tui/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "110e4095252b534dd1962f5e955e6eaa18c977ade58b11c0b4dfb0e5ead94208"
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
