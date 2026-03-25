class Authalla < Formula
  desc "CLI tool for the Authalla platform"
  homepage "https://authalla.com"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/authalla/authalla-cli/releases/download/v1.0.0/authalla-aarch64-apple-darwin.tar.xz"
      sha256 "d2dc0c5cd03e346d57cab2b9de8a0b3a2bad34bd47c83f6d74d4949ca4e09b97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/authalla/authalla-cli/releases/download/v1.0.0/authalla-x86_64-apple-darwin.tar.xz"
      sha256 "a834ca5aa5936a2ddc700db4e7a89abbac2eac10fd23152c8d8e5700da39a474"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/authalla/authalla-cli/releases/download/v1.0.0/authalla-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "821d100dc261633aac23b6afb5534ab48886ea9815bbc77f7b98575298bef663"
    end
    if Hardware::CPU.intel?
      url "https://github.com/authalla/authalla-cli/releases/download/v1.0.0/authalla-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6020c067b8c9fa69afc5f416e6453525fd4a447c012d250c3ef55f7487ecb19d"
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
