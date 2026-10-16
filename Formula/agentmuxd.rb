class Agentmuxd < Formula
  desc "Connect mobile agents to Mac tmux sessions over SSH or iroh"
  homepage "https://github.com/xbunax/agentmux"
  url "https://github.com/xbunax/agentmux/archive/08084ce6754a446e2f11899868d5510d30751f12.tar.gz"
  version "0.1.0"
  revision 1
  sha256 "9668bad31018142c0db204fe65bc35ef5327ff49d4863fe3ddfe3e49680dc505"
  head "https://github.com/xbunax/agentmux.git", branch: "main"

  depends_on "rust" => :build
  depends_on :macos
  depends_on "tmux"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", ".", "--bin", "agentmuxd"
  end

  service do
    run [opt_bin/"agentmuxd"]
    keep_alive true
    working_dir Dir.home
    environment_variables PATH: "#{Dir.home}/.local/bin:#{Dir.home}/.cargo/bin:#{std_service_path_env}",
                          LANG: "en_US.UTF-8",
                          AGENTMUX_CONFIG: "#{Dir.home}/.config/agentmux/agentmux.json",
                          AGENTMUX_STATE: "#{Dir.home}/.config/agentmux/state",
                          AGENTMUX_TMUX: Formula["tmux"].opt_bin/"tmux"
    log_path var/"log/agentmuxd.log"
    error_log_path var/"log/agentmuxd.error.log"
  end

  def caveats
    <<~EOS
      Configuration: ~/.config/agentmux/agentmux.json
      Device credentials and state: ~/.config/agentmux/state/

      Before upgrading from a project-local installation, copy agentmux.json and
      .agentmux/ to the locations above to preserve existing iPhone pairing.
      Stop any manually launched agentmuxd before starting this service.
      Start as your login user (without sudo), so it can access your tmux sessions:
        brew services start xbunax/tap/agentmuxd

      To pair without SSH, run locally while this service is running:
        agentmuxd pair --transport iroh
      In AgentMux for iOS 17.5+, scan the resulting QR code.
      The code expires in five minutes; each code can be used only once.
      SSH remains available; enable macOS Remote Login to use SSH login.
      Install and log in to the agent CLIs separately. Configure their absolute
      executable paths if they are not on the service PATH.
    EOS
  end

  test do
    require "net/http"
    require "timeout"

    port = free_port
    token = "homebrew-agentmux-test-credential-0000"
    env = {
      "AGENTMUX_API_PORT" => port.to_s,
      "AGENTMUX_CONFIG" => (testpath/"agentmux.json").to_s,
      "AGENTMUX_STATE" => (testpath/"state").to_s,
      "AGENTMUX_DISCOVERY" => (testpath/"service.json").to_s,
      "AGENTMUX_BRIDGE_DIR" => (testpath/"bridges").to_s,
      "AGENTMUX_SSH_DISABLED" => "1",
      "AGENTMUX_TOKEN" => token,
    }
    pid = spawn(env, (bin/"agentmuxd").to_s, chdir: testpath, out: testpath/"service.log", err: [:child, :out])
    begin
      uri = URI("http://127.0.0.1:#{port}/v1/settings")
      response = Timeout.timeout(20) do
        loop do
          begin
            break Net::HTTP.get_response(uri)
          rescue Errno::ECONNREFUSED
            sleep 0.1
          end
        end
      end
      assert_equal "401", response.code
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{token}"
      response = Net::HTTP.start(uri.host, uri.port) { |http| http.request(request) }
      assert_equal "200", response.code
      assert_equal [testpath.realpath.to_s], JSON.parse(response.body).fetch("roots")
      assert_path_exists testpath/"state/ssh_host_ed25519"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
