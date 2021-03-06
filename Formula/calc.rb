class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.12.7.1/calc-2.12.7.1.tar.bz2"
  sha256 "eb1dc5dd680019e30264109167e20539fe9ac869049d8b1639781a51d1dea84c"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "d78863a41409a2e3eaee0b8e4c5eb21a84ee28f1c3f8a27545d6e1f3fe3ae213" => :catalina
    sha256 "1b4e5456d4965f8b74c120590070f74896c1fca85c8aa30354ffe519c1755600" => :mojave
    sha256 "7614247fc707caf03a96e302ab2e1324f6a3609cfd1cdd7c6389bca77511ff18" => :high_sierra
    sha256 "c31e4ac4a08ff6f1803cfcbe2d90a2634737ed69f4c38538f7ba77fc6a3e6728" => :sierra
    sha256 "aa397c39014605519cf2c3b441559197c4fa1f1f1dffec06d6ae8e7952f95f30" => :x86_64_linux
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    readline = Formula["readline"]

    system "make", "install", *("INCDIR=#{MacOS.sdk_path}/usr/include" if OS.mac?),
                              "BINDIR=#{bin}",
                              "LIBDIR=#{lib}",
                              "MANDIR=#{man1}",
                              "CALC_INCDIR=#{include}/calc",
                              "CALC_SHAREDIR=#{pkgshare}",
                              "USE_READLINE=-DUSE_READLINE",
                              "READLINE_LIB=-L#{readline.opt_lib} -lreadline",
                              "READLINE_EXTRAS=-lhistory -lncurses"
    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
