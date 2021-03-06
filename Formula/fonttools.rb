class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.16.1/fonttools-4.16.1.zip"
  sha256 "991eb05e0366af5a6e620551f950a4f49433c5a8de70770a7066bcbe78bb86cc"
  license "MIT"
  revision OS.mac? ? 1 : 2
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0fc8efd6caaabf9b3340e2eb6d84ebba1f4065e7f82869262f4fb69dfbe115b" => :catalina
    sha256 "ec3b0c20e2f9517ff3037e07b07881e4d8d4e0a765735bb6a136635ae6d13112" => :mojave
    sha256 "ee8e0c4b45dcbeb31f147907e257a1478972dca701556755a8149510245f571c" => :high_sierra
    sha256 "baea3e221d17b5c2576d00b9176f672946bcad0a7eda6ee7940f4256e41cb555" => :x86_64_linux
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    unless OS.mac?
      assert_match "usage", shell_output("#{bin}/ttx -h")
      return
    end
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
