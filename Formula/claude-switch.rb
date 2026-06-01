class ClaudeSwitch < Formula
  desc "TUI tool for switching Claude Code API backends"
  homepage "https://github.com/xbunax/claude-switch-tui"
  url "https://github.com/xbunax/claude-switch-tui/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "75d8800446c40de2231c86429dc587fb142c82632b3e8b63679d9a508d41e734"
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
