#!/usr/bin/env bash
set -euo pipefail

ver=$(curl -fsSL https://www.rarlab.com/download.htm \
  | grep -oE 'rarmacos-arm-[0-9]+\.tar\.gz' | head -1 | grep -oE '[0-9]+')
dotted="${ver:0:1}.${ver:1}"
sha() { curl -fsSL "https://www.rarlab.com/rar/rarmacos-$1-$ver.tar.gz" | shasum -a 256 | cut -d' ' -f1; }

cat > $OH_MY_GIL_SH/Formula/rar.rb <<EOF
class Rar < Formula
  desc "RAR archiver command-line tools from RARLAB"
  homepage "https://www.rarlab.com/"
  version "$dotted"

  on_arm do
    url "https://www.rarlab.com/rar/rarmacos-arm-$ver.tar.gz"
    sha256 "$(sha arm)"
  end
  on_intel do
    url "https://www.rarlab.com/rar/rarmacos-x64-$ver.tar.gz"
    sha256 "$(sha x64)"
  end

  def install
    bin.install "rar", "unrar"
    doc.install Dir["*.txt"]
  end
end
EOF
echo "rar formula updated to $dotted"
