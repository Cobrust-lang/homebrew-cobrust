# homebrew-cobrust

Homebrew tap for [Cobrust](https://github.com/Cobrust-lang/cobrust) — a Rust-implemented Python successor with an AI-native compiler.

## Install

```bash
brew tap cobrust-lang/cobrust
brew install cobrust
```

Verify the install:

```bash
cobrust --version    # prints v0.6.0
cobrust-lsp --help   # LSP server is on PATH
cobrust-dap --help   # DAP shim is on PATH
```

## Upgrade

Updates ship as new releases on the main [Cobrust-lang/cobrust](https://github.com/Cobrust-lang/cobrust) repo. To pull the latest:

```bash
brew update
brew upgrade cobrust
```

## What gets installed

The tap installs prebuilt binaries from the matching [Cobrust release](https://github.com/Cobrust-lang/cobrust/releases). Layout per ADR-0069 (FHS):

- `bin/cobrust`, `bin/cobrust-lsp`, `bin/cobrust-dap` — compiler driver, LSP server, DAP shim
- `lib/cobrust/libcobrust_stdlib.a` — stdlib static archive
- `share/cobrust/runtime/` — C runtime sources (`cobrust_main.c`, `cpu_features.c`)

## Platforms

| OS | Arch | Variant served |
|---|---|---|
| macOS | Apple Silicon (arm64) | `aarch64-apple-darwin-m1` (M1-tuned baseline; M2 users may opt into the `m2` tarball manually) |
| Linux | x86_64 | `x86_64-unknown-linux-gnu-v3` (AVX2; modern Intel/AMD) |
| Linux | aarch64 | `aarch64-unknown-linux-gnu-neon` (universal baseline) |

For x86_64-v1 / v4, musl, ARM SVE, or M2-tuned tarballs, install manually from [v0.6.0 release assets](https://github.com/Cobrust-lang/cobrust/releases/tag/v0.6.0).

## Editor integration

Once `cobrust-lsp` is on PATH (which `brew install cobrust` ensures), the official [Cobrust extension on Open VSX](https://open-vsx.org/extension/Cobrust-lang/cobrust) (VSCode + Cursor + Codium) auto-discovers the LSP server. No further config needed.

## Auto-update

The formula auto-bumps via [`.github/workflows/auto-bump.yml`](.github/workflows/auto-bump.yml), which polls the [main Cobrust repo](https://github.com/Cobrust-lang/cobrust) hourly for new releases and rewrites `Formula/cobrust.rb` with the new version + per-platform SHA256s (sourced from each release's `SHA256SUMS` asset). The workflow is also `workflow_dispatch`-triggerable for an immediate refresh.

A new upstream release (e.g. `v0.6.2`) is reflected in this tap within roughly one hour, with no manual intervention.

## Troubleshooting

### Stuck install / `.incomplete` lockfile

If `brew install cobrust` fails partway and subsequent retries hang, refuse to redownload, or report an "already in cellar" / lockfile error, Homebrew likely has a stale partial download or lock. Recover with:

```bash
brew cleanup cobrust
# If that doesn't clear it, remove stale partial downloads explicitly:
rm -f "$(brew --cache)"/downloads/*cobrust*.incomplete
rm -f "$(brew --cache)"/*cobrust*.incomplete
brew install cobrust   # retry
```

For a full clean reinstall (drops the cellar entry and re-taps):

```bash
brew uninstall --force cobrust  || true
brew untap   cobrust-lang/cobrust || true
brew tap     cobrust-lang/cobrust
brew install cobrust
```

If the install still fails after the cache is clear, please [open an issue](https://github.com/Cobrust-lang/homebrew-cobrust/issues) with `brew config` + `brew install -d cobrust` output attached.

## Links

- Main repo: <https://github.com/Cobrust-lang/cobrust>
- Releases: <https://github.com/Cobrust-lang/cobrust/releases>
- VSCode / Cursor extension: <https://open-vsx.org/extension/Cobrust-lang/cobrust>

## License

The formula itself is Apache-2.0 OR MIT, matching Cobrust upstream.
