class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://files.pythonhosted.org/packages/0f/45/4d3bd56a3840d384ee0a24270658d139780ceb5a2f3e7aa3cb10d5e46360/wakatime-13.0.7.tar.gz"
  sha256 "07a6d07e1227e3bd45242a2a4861d105bddc6220174a9b739c551bd2d45ce0fd"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d275f57a3ac6975be6b3fb65ab6d788b767c9c7bfc4c6471b61881b14f858586" => :catalina
    sha256 "391196df0c849c90c8fad31b1c7fe29668cc4999fc3805ff54770c01820dfd5a" => :mojave
    sha256 "e8ec76f4f302361f95d2a462f88fd12687e036da8cc6acee381499cbaf196b50" => :high_sierra
    sha256 "d8eac099e3292688f4195284f3fced68e3da91639417069d3724b4e203e790fc" => :x86_64_linux
  end

  depends_on "python@3.9"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    assert_match "Common interface for the WakaTime api.", shell_output("#{bin}/wakatime --help 2>&1")

    assert_match "error: Missing api key.", shell_output("#{bin}/wakatime --project test 2>&1", 104)
  end
end
