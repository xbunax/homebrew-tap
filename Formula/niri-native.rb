class NiriNative < Formula
  desc "Tiling window manager for macOS with native Spaces"
  homepage "https://github.com/xbunax/niri-native"
  url "https://github.com/xbunax/niri-native/releases/download/v0.8.6/rift-universal-macos-0.8.6.tar.gz"
  sha256 "5e95c098315f3021ada8ccfe7dde70a32ff040400e917132afb3228d6be70937"
  license "Apache-2.0"

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

      To copy the default configuration without replacing an existing file:
        mkdir -p ~/.config/rift-native
        cp -n "#{pkgshare}/rift.default.toml" ~/.config/rift-native/config.toml

      Start manually with:
        niri-native
    EOS
  end

  test do
    assert_equal "niri-native #{version}", shell_output("#{bin}/niri-native --version").strip
    assert_equal "niri-native-cli #{version}", shell_output("#{bin}/niri-native-cli --version").strip
    assert_path_exists pkgshare/"rift.default.toml"
  end
end
