class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "https://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.31.0/fullsrc.zip"
  sha256 "e5111ece8e6350f5d530d4b17003c2019be27017c5dec75c488587e942c502a0"
  license "GPL-3.0"
  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "804d64c9c1d99dc5f94e9219f9fccee72745ec25f96a47a297f869b5504e6682" => :catalina
    sha256 "f833634da5af3a4596412cd06860b12d685b0e60ca2005ffb8968507d312feab" => :mojave
    sha256 "10b5be3c5be1f1cb3ef9a905755491a17d84fe7d4453169717aa0ee5bd19d45d" => :high_sierra
    sha256 "9cba58c1e156cec46d0413c10968ee2563096b43c879f093a4a66f5ef3d83c56" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on macos: :sierra # fibjs requires >= Xcode 8.3 (or equivalent CLT)

  depends_on "llvm" => :build unless OS.mac?

  def install
    # the build script breaks when CI is set by Homebrew
    begin
      env_ci = ENV.delete "CI"
      system "./build", "release", "-j#{ENV.make_jobs}"
    ensure
      ENV["CI"] = env_ci
    end

    bin.install "bin/#{OS.mac? ? "Darwin" : "Linux"}_amd64_release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end
