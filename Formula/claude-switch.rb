class ClaudeSwitch < Formula
  desc "TUI tool for switching Claude Code API backends"
  homepage "https://github.com/xbunax/claude-switch-tui"
  url "https://github.com/xbunax/claude-switch-tui/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "5ee5063f997311c5cfda16d02b4fa991ae79cdaa29b5ddec2289a27cc6b4ff2b"
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
