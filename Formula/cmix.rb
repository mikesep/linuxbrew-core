class Cmix < Formula
  desc "Data compression program with high compression ratio"
  homepage "https://www.byronknoll.com/cmix.html"
  url "https://github.com/byronknoll/cmix/archive/v18.tar.gz"
  version "18.0.0"
  sha256 "2f0272186a8ff693146d0d8070ad4d9687461a486805ab91d727891df316498d"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9dbbd3e8367f799405fbb237d68fe46e968bda502a5779f3be1c467b56e394b8" => :catalina
    sha256 "448fa06555b59d6a0541d1e36ff9eac14e05775fd2ef119e860a305368b800ec" => :mojave
    sha256 "6e1bc1de5f3c36e6fcda7874b8fbd18938aedbdbce94039763302f9643964a0a" => :high_sierra
    sha256 "3dc97bda2656e2b2ffccb50915f9a981513fff5a8f90af2a1c5521afe52568d0" => :sierra
    sha256 "778bb75257364cd8793b1adae549d2e354e52679e9ae2f4e74995bef1505e57b" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "cmix"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/cmix", "-c", "foo", "foo.cmix"
    system "#{bin}/cmix", "-d", "foo.cmix", "foo.unpacked"
    assert_equal "test", shell_output("cat foo.unpacked")
  end
end
