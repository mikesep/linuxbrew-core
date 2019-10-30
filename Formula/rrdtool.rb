class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/index.en.html"
  url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.7.2/rrdtool-1.7.2.tar.gz"
  sha256 "a199faeb7eff7cafc46fac253e682d833d08932f3db93a550a4a5af180ca58db"

  bottle do
    cellar :any
    sha256 "fdf30d365db065b6b6a7b7d48d86122dde11d1f0ef4a8fc0d5447b4b78e3511b" => :catalina
    sha256 "7b3548ea861690d6507de212fe55808c9120424b6b9c73a5fc9ac960b252685a" => :mojave
    sha256 "a93a0f09da257b0e9fd429727ad1d7afbfe8ca8b19aaa299f77f6719954b8432" => :high_sierra
    sha256 "42323cefde415bf4d129f4a619f1a40acc517f6cfa52a584aadf286c6cf72f9d" => :sierra
  end

  head do
    url "https://github.com/oetiker/rrdtool-1.x.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "pango"

  def install
    # fatal error: 'ruby/config.h' file not found
    ENV.delete("SDKROOT")

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-tcl
      --with-tcllib=/usr/lib
      --disable-perl-site-install
      --disable-ruby-site-install
    ]

    inreplace "configure", /^sleep 1$/, "#sleep 1"

    system "./bootstrap" if build.head?
    system "./configure", *args

    # Needed to build proper Ruby bundle
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}", "install"
    prefix.install "bindings/ruby/test.rb"
  end

  test do
    system "#{bin}/rrdtool", "create", "temperature.rrd", "--step", "300",
      "DS:temp:GAUGE:600:-273:5000", "RRA:AVERAGE:0.5:1:1200",
      "RRA:MIN:0.5:12:2400", "RRA:MAX:0.5:12:2400", "RRA:AVERAGE:0.5:12:2400"
    system "#{bin}/rrdtool", "dump", "temperature.rrd"
  end
end
