class Authalla < Formula
  desc "CLI tool for the Authalla OAuth2 API"
  homepage "https://authalla.com"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.2.0/authalla-aarch64-apple-darwin.tar.xz"
      sha256 "988438e454158b0c49b96896bff1be3af115cb9ddf5f28b116498f3cc84af27c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.2.0/authalla-x86_64-apple-darwin.tar.xz"
      sha256 "d30686a05116ba71224d7f062dd156995d96fcbe854a16f1d4b953a6cebeffbb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.2.0/authalla-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bf0a49416d243aba9a1cdb1ff8c88e5dc197712dfc53091eaded636f963aeb3b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.2.0/authalla-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "257d83c67ee56aa4e90a1e78a85f04a8e00daa92e262802b7eb277f4bffa5ed6"
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
