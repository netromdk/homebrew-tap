class F2format < Formula
  include Language::Python::Virtualenv

  desc "Backport compiler for Python 3.6 f-string literals"
  homepage "https://github.com/pybpc/f2format#f2format"
  url "https://github.com/pybpc/f2format/archive/v0.8.6.tar.gz"
  sha256 "b4ca53f4e3bb571a3222f795f6169e0487872278436e5812412e0fad4cfceef4"
  revision 1

  head "https://github.com/pybpc/f2format.git", :branch => "master"

  depends_on "python@3.8"

  resource "parso" do
    url "https://files.pythonhosted.org/packages/e0/a2/3786c568fc8e9f64b9f7143e4c3904e61a8c5cb17260f22a6a3019d80c02/parso-0.5.2.tar.gz"
    sha256 "55cf25df1a35fd88b878715874d2c4dc1ad3f0eebd1e0266a67e1f55efccfbe1"
  end

  resource "tbtrim" do
    url "https://files.pythonhosted.org/packages/85/62/89756f5d2d61691591c4293fd4cc1fbb3aab1466251c7319fe60dd08fb27/tbtrim-0.3.1.tar.gz"
    sha256 "b6285ac02e9a7b78fab97de65668fe2def0f5d8783b0e0dfcb4b7c0a635b3d11"
  end

  def install
    virtualenv_install_with_resources
    man1.install "share/f2format.1"
    bash_completion.install "share/f2format.bash-completion"
  end

  test do
    (testpath/"test.py").write <<~EOS
      var = f'foo{(1+2)*3:>5}bar{"a", "b"!r}boo'
    EOS

    std_output = <<~EOS
      var = 'foo{:>5}bar{!r}boo'.format((1+2)*3, ("a", "b"))
    EOS

    system bin/"f2format", "--no-archive", "test.py"
    assert_match std_output, shell_output("cat test.py")
  end
end
