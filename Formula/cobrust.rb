class Cobrust < Formula
  desc "Rust-implemented Python successor with AI-native compiler"
  homepage "https://github.com/Cobrust-lang/cobrust"
  version "0.6.1"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      # Apple Silicon M1 (default for arm64 macOS).
      # M2-tuned variant also published; users on M2+ may prefer the m2 tarball.
      url "https://github.com/Cobrust-lang/cobrust/releases/download/v0.6.1/cobrust-v0.6.1-aarch64-apple-darwin-m1.tar.gz"
      sha256 "2d998c1caec08d8cd27b2f9aba30b18e9300ccb8d25905a6688ef108a1eba416"
    end
  end

  on_linux do
    on_intel do
      # Default to x86_64-v3 (AVX2) for modern Intel/AMD.
      # v1 / v4 variants are also published; v4 requires AVX-512.
      url "https://github.com/Cobrust-lang/cobrust/releases/download/v0.6.1/cobrust-v0.6.1-x86_64-unknown-linux-gnu-v3.tar.gz"
      sha256 "1b51abbc503ef2ca047c3c2844c5d20e908946c715c61ab591b69699ea8a23d7"
    end
    on_arm do
      # ARM neon (universal aarch64 baseline). SVE variant also published.
      url "https://github.com/Cobrust-lang/cobrust/releases/download/v0.6.1/cobrust-v0.6.1-aarch64-unknown-linux-gnu-neon.tar.gz"
      sha256 "bcac9f046556a4d3ee5a4cddc99ce9bf089a35db417854418f5a0c298d97f329"
    end
  end

  def install
    # Wheel layout per ADR-0069 FHS:
    #   bin/                 cobrust + cobrust-lsp + cobrust-dap (shim)
    #   lib/cobrust/         libcobrust_stdlib.a
    #   share/cobrust/runtime/  cobrust_main.c + cpu_features.c
    bin.install Dir["bin/*"]
    (lib/"cobrust").install Dir["lib/cobrust/*"]
    (share/"cobrust").install Dir["share/cobrust/runtime"]
  end

  test do
    # Smoke: compile + run a trivial program.
    (testpath/"hello.cb").write <<~EOF
      fn main() -> i64:
          print("brew smoke")
          return 0
    EOF
    system bin/"cobrust", "run", testpath/"hello.cb"
  end
end
