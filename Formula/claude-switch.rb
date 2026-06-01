class ClaudeSwitch < Formula
  desc "TUI tool for switching Claude Code API backends"
  homepage "https://github.com/xbunax/claude-switch-tui"
  url "https://github.com/xbunax/claude-switch-tui/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "0197a54c1b2e3115a05b2adbed4dcf5e355625f65ab6c1241e9e2de00db36b3f"
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
