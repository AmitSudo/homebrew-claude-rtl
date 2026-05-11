class ClaudeRtl < Formula
  desc "RTL (right-to-left) text support for Claude Desktop on macOS"
  homepage "https://github.com/AmitSudo/claude-rtl"
  url "https://github.com/AmitSudo/claude-rtl/archive/refs/heads/main.tar.gz"
  version "1.0.0"
  license "MIT"

  depends_on :macos
  depends_on "node"

  def install
    libexec.install "rtl.js", "install.sh", "uninstall.sh", "watcher.sh"
    bin.write_exec_script libexec/"install.sh"

    # Create convenience commands
    (bin/"claude-rtl").write <<~EOS
      #!/bin/bash
      case "${1:-install}" in
        install)  bash "#{libexec}/install.sh" ;;
        uninstall) bash "#{libexec}/uninstall.sh" ;;
        reapply)  bash "$HOME/.claude-rtl/reapply.sh" ;;
        revert)   bash "$HOME/.claude-rtl/revert.sh" ;;
        *) echo "Usage: claude-rtl [install|uninstall|reapply|revert]" ;;
      esac
    EOS
  end

  def caveats
    <<~EOS
      To install the RTL patch:
        claude-rtl install

      To uninstall:
        claude-rtl uninstall

      The patch is automatically re-applied after Claude Desktop updates
      via a background watcher (LaunchAgent).
    EOS
  end
end
