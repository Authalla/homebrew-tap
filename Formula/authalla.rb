class Authalla < Formula
  desc "CLI tool for the Authalla OAuth2 API"
  homepage "https://authalla.com"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.1.0/authalla-aarch64-apple-darwin.tar.xz"
      sha256 "ef9b49d6d66b9301662acb9ffa0005519e9663ca292ff6c7f176cec52c006e85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.1.0/authalla-x86_64-apple-darwin.tar.xz"
      sha256 "f16d57741046d54373a53255927bfd07708602b938b163cdffef91b6bc24c2a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.1.0/authalla-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "30517ead487d85b3f042158347a6a111638b56642956d884a4733b5b8fcebfdd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.1.0/authalla-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b7f9c7b5ed05c4f966a7d05f4c4c05a9d8288bba518de89a849c87b97d457404"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "authalla" if OS.mac? && Hardware::CPU.arm?
    bin.install "authalla" if OS.mac? && Hardware::CPU.intel?
    bin.install "authalla" if OS.linux? && Hardware::CPU.arm?
    bin.install "authalla" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
