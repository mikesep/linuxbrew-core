class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
    tag:      "4.19",
    revision: "f9902cb938911b674f69da4c085eb4a4bebf9cf4"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "54257b991eca3725c03ed737d38158f2c9406b29fe035ed43a59dda6ac0400d2" => :catalina
    sha256 "045b3d231e384da1ac603b3f7f4d0b96b86bccfb208e93148aa56fee0d7baffa" => :mojave
    sha256 "b1025a09b10689b8562959ed6e6e37c77d04765285ba64fde51bbf385e15ff29" => :high_sierra
    sha256 "816f142a217c5b28adefdb3d02066936dd15d09de7c660b6129699e5d47bb547" => :x86_64_linux
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    if OS.mac?
      assert_match "brewing",
        shell_output("script -q /dev/null #{bin}/reposurgeon read list")
    else
      assert_match "brewing",
        shell_output("script -q /dev/null -c \"#{bin}/reposurgeon read list\"")
    end
  end
end
