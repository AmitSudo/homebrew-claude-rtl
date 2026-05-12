class ClaudeRtl < Formula
  desc "RTL (right-to-left) text support for Claude Desktop on macOS"
  homepage "https://github.com/AmitSudo/claude-rtl"
  url "https://github.com/AmitSudo/claude-rtl/archive/refs/heads/main.tar.gz"
  version "2.0.0"
  license "MIT"

  depends_on :macos
  depends_on "node"

  def install
    libexec.install "rtl.js", "install.sh", "uninstall.sh"

    (bin/"claude-rtl").write <<~EOS
      #!/bin/bash
      case "${1:-install}" in
        install)   bash "#{libexec}/install.sh" ;;
        uninstall) bash "#{libexec}/uninstall.sh" ;;
        *)
          echo "Usage: claude-rtl [install|uninstall]"
          echo ""
          echo "  install    Build ~/Applications/Claude-RTL.app from /Applications/Claude.app"
          echo "  uninstall  Remove ~/Applications/Claude-RTL.app"
          exit 1
          ;;
      esac
    EOS
  end

  def caveats
    <<~EOS
      Install the patched Claude Desktop copy:
        claude-rtl install

      Uninstall:
        claude-rtl uninstall

      How it works:
        The installer creates a patched copy at ~/Applications/Claude-RTL.app.
        Your original /Applications/Claude.app is never modified.

        - Open Claude.app       for features that need Anthropic's original
                                signed bundle (e.g. Cowork).
        - Open Claude-RTL.app   for Hebrew/Arabic chats.

        Both apps share login state via the same bundle identifier.

      After Claude Desktop updates:
        Re-run "claude-rtl install" to rebuild the patched copy on top of
        the latest source app.
    EOS
  end

  test do
    assert_predicate bin/"claude-rtl", :executable?
    output = shell_output("#{bin}/claude-rtl 2>&1", 1)
    assert_match "Usage: claude-rtl", output
  end
end
