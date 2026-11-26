class NiriNative < Formula
  desc "Tiling window manager for macOS with native Spaces"
  homepage "https://github.com/xbunax/niri-native"
  url "https://github.com/xbunax/niri-native/releases/download/v0.1.0/rift-universal-macos-0.1.0.tar.gz"
  sha256 "144ef718e765ea08796c2ea56e4c773aa8c74bdd46cbc67fa4d6f941d5b0c917"
  license "Apache-2.0"
  # 0.8.6 inherited Rift's version; niri-native now uses its own numbering.
  version_scheme 1

  depends_on :macos

  def install
    # Leave the legacy command names to the upstream Rift formula.
    bin.install "niri-native", "niri-native-cli"
    pkgshare.install "rift.default.toml"
  end

  def caveats
    <<~EOS
      Grant niri-native Accessibility permission in System Settings > Privacy & Security.
      Stop any running window manager before starting niri-native; this formula does not start a service.

      Existing ~/.config/rift-native/config.toml files remain supported. New users can copy the default:
        mkdir -p ~/.config/niri-native
        cp -n "#{pkgshare}/rift.default.toml" ~/.config/niri-native/config.toml

      Start manually with niri-native, or enable the per-user LaunchAgent:
        niri-native service install
        niri-native service start

      If the service is already installed, use niri-native service start.
    EOS
  end

  test do
    assert_equal "niri-native #{version}", shell_output("#{bin}/niri-native --version").strip
    assert_equal "niri-native-cli #{version}", shell_output("#{bin}/niri-native-cli --version").strip
    assert_path_exists pkgshare/"rift.default.toml"
  end
end
