class Authalla < Formula
  desc "CLI tool for the Authalla OAuth2 API"
  homepage "https://authalla.com"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.3.0/authalla-aarch64-apple-darwin.tar.xz"
      sha256 "c16532f5fc180159d6b793f2d13b56eef247202e0439c76f6cc7ce5cb4101731"
    end
    if Hardware::CPU.intel?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.3.0/authalla-x86_64-apple-darwin.tar.xz"
      sha256 "6f04bb274ecabd0ee7221dfb474d8daad468fa971436b1d825b1dd9d0470af6b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.3.0/authalla-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f199da5609a42caed5c0e9a6dae3c12c787c3a61eeaf4d4f13380c28df7e587"
    end
    if Hardware::CPU.intel?
      url "https://github.com/authalla/authalla-cli/releases/download/v0.3.0/authalla-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f01adc5447371ba14f7cc13d36c3a1bac0d83bcc0a5dec42c8363290dc9c2e2c"
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
