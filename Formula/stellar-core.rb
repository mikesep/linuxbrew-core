class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v14.1.1",
      revision: "5b2989d334f578b00ac9b5996888257f5922a8a4"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "8e9001b7f61c4226a09a6a5562e83ac0e4338408180de8f3718828420ec65201" => :catalina
    sha256 "3c029b977e4c76251f15cd95546ba2214b7a4f798ef81f7d7b09f213131f1730" => :mojave
    sha256 "dac965ffd62b460ef84357e52afcc5c1d405dd1ec452e77ac8c6198f005713c6" => :high_sierra
    sha256 "0b5d2c83309bcc7b95b6b71f4840b0a8380908d165a54fc14f74ef3fa5f16fb8" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "parallel" => :test
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  unless OS.mac?
    # Needs libraries at runtime:
    # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.22' not found
    depends_on "gcc@6"
    fails_with gcc: "5"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-postgres"
    system "make", "install"
  end

  test do
    system "#{bin}/stellar-core", "test",
      "'[bucket],[crypto],[herder],[upgrades],[accountsubentriescount]," \
      "[bucketlistconsistent],[cacheisconsistent],[fs]'"
  end
end
