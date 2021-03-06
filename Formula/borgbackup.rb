class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://github.com/borgbackup/borg/releases/download/1.1.14/borgbackup-1.1.14.tar.gz"
  sha256 "7dbb0747cc948673f695cd6de284af215f810fed2eb2a615ef26ddc7c691edba"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "d284ec02d4b2fb3b63882a9bfe8bd2300c96969c9ba2536a69e7e44c87c36297" => :catalina
    sha256 "927973da8c7146ff1ea17efd7fe742631866d554ccc9334b857d55bfcc666068" => :mojave
    sha256 "ae4e81b65c73e3d2f3c0d34442321db0ef8a25d9f424d8f411643f29d89ba22a" => :high_sierra
  end

  depends_on osxfuse: :build
  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "python@3.8"
  depends_on "zstd"

  resource "llfuse" do
    url "https://files.pythonhosted.org/packages/75/b4/5248459ec0e7e1608814915479cb13e5baf89034b572e3d74d5c9219dd31/llfuse-1.3.6.tar.bz2"
    sha256 "31a267f7ec542b0cd62e0f1268e1880fdabf3f418ec9447def99acfa6eff2ec9"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use `borg mount`, install osxfuse with Homebrew Cask:
        brew cask install osxfuse
    EOS
  end

  test do
    # Create a repo and archive, then test extraction.
    cp test_fixtures("test.pdf"), testpath
    Dir.chdir(testpath) do
      system "#{bin}/borg", "init", "-e", "none", "test-repo"
      system "#{bin}/borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    end
    mkdir testpath/"restore" do
      system "#{bin}/borg", "extract", testpath/"test-repo::test-archive"
    end
    assert_predicate testpath/"restore/test.pdf", :exist?
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end
