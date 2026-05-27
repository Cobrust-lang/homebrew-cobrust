class Cobrust < Formula
  desc "Rust-implemented Python successor with AI-native compiler"
  homepage "https://github.com/Cobrust-lang/cobrust"
  version "0.6.2"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      # Apple Silicon M1 (default for arm64 macOS).
      # M2-tuned variant also published; users on M2+ may prefer the m2 tarball.
      url "https://github.com/Cobrust-lang/cobrust/releases/download/v0.6.2/cobrust-v0.6.2-aarch64-apple-darwin-m1.tar.gz"
      sha256 "ecfc24b6bd74ed02979f3945b99acf4a9d2e4f7429ede8f68470b41800a9caa2"
    end
  end

  on_linux do
    on_intel do
      # Default to x86_64-v3 (AVX2) for modern Intel/AMD.
      # v1 / v4 variants are also published; v4 requires AVX-512.
      url "https://github.com/Cobrust-lang/cobrust/releases/download/v0.6.2/cobrust-v0.6.2-x86_64-unknown-linux-gnu-v3.tar.gz"
      sha256 "b5381a12f8e3ad99ab2af638294d82988510a2e2cf6010aff6a2415990619412"
    end
    on_arm do
      # ARM neon (universal aarch64 baseline). SVE variant also published.
      url "https://github.com/Cobrust-lang/cobrust/releases/download/v0.6.2/cobrust-v0.6.2-aarch64-unknown-linux-gnu-neon.tar.gz"
      sha256 "cbbe557ae5d9754e44ce3ae3fc05dccdab86b02571150c9d1aa74755c2289dc7"
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
