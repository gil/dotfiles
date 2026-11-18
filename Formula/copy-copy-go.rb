#
# Install:
# brew tap gil/dotfiles https://github.com/gil/dotfiles
# brew install --HEAD gil/dotfiles/copy-copy-go
#
# Update:
# brew upgrade --fetch-HEAD copy-copy-go
#
class CopyCopyGo < Formula
  desc "Menu bar app for quick translation (just Cmd+C twice)"
  homepage "https://github.com/gil/copy-copy-go"
  head "https://github.com/gil/copy-copy-go.git", branch: "main"

  depends_on xcode: ["26.0", :build]
  depends_on "xcodegen" => :build
  depends_on macos: :tahoe

  def install
    system "xcodegen", "generate"
    xcodebuild "-project", "CopyCopyGo.xcodeproj",
               "-scheme", "CopyCopyGo",
               "-configuration", "Release",
               "-destination", "platform=macOS",
               "-derivedDataPath", "build",
               "-quiet", "build",
               # Swift macros (@State, @Observable) fail inside Homebrew's sandbox otherwise
               "OTHER_SWIFT_FLAGS=-disable-sandbox"
    prefix.install "build/Build/Products/Release/CopyCopyGo.app"
  end

  def caveats
    <<~EOS
      To add the app to /Applications, run:
        ln -sfn "#{opt_prefix}/CopyCopyGo.app" /Applications/CopyCopyGo.app

      To update to the latest version, run:
        brew upgrade --fetch-HEAD copy-copy-go
    EOS
  end
end
