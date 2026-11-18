class Rar < Formula
  desc "RAR archiver command-line tools from RARLAB"
  homepage "https://www.rarlab.com/"
  version "7.23"

  on_arm do
    url "https://www.rarlab.com/rar/rarmacos-arm-723.tar.gz"
    sha256 "68b393c000758d477fde43c955ff7542f12f76f3f5e87cdda923152fc791bd4d"
  end
  on_intel do
    url "https://www.rarlab.com/rar/rarmacos-x64-723.tar.gz"
    sha256 "da1fb3c3d7748136c9b369b683d574b372cb1ed049a634a81f85d93918346d8f"
  end

  def install
    bin.install "rar", "unrar"
    doc.install Dir["*.txt"]
  end
end
