<!-- file: README.md -->
<!-- version: 1.1.0 -->
<!-- guid: 7e3a9f2d-4b8c-4e1a-9d6f-2c7e4a1b9d5e -->

# Release Go Module Action

GitHub Action for releasing Go modules with GoReleaser, automatic SDK tagging
and multi-module repository support.

## Features

- 🚀 Powered by GoReleaser for professional-grade releases
- 📦 Multi-module repository support
- 🏷️ SDK-specific tagging (e.g., `go/v1.2.3`, `python/v1.2.3`)
- ✅ Built-in testing and linting
- 📝 Automatic GitHub release creation with artifacts
- 🔍 Module validation
- 🎯 Cross-platform binary builds
- 📊 Automatic checksums and archives

## Usage

### Basic Example

```yaml
- name: Release Go module
  uses: jdfalk/release-go-action@v1
  with:
    tag: v1.0.0
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

### With GoReleaser Configuration

```yaml
- name: Release Go module with custom config
  uses: jdfalk/release-go-action@v1
  with:
    tag: v1.0.0
    goreleaser-config: .goreleaser.yml
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

### Multi-Module Repository

```yaml
- name: Release auth module
  uses: jdfalk/release-go-action@v1
  with:
    module-path: pkg/auth
    tag: v1.2.3
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

### SDK Module with Custom Tagging

```yaml
- name: Release Go SDK
  uses: jdfalk/release-go-action@v1
  with:
    module-path: sdk/go
    tag: v2.0.0
    is-sdk: true
    sdk-language: go
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

### Advanced Example

```yaml
- name: Release Go module
  uses: jdfalk/release-go-action@v1
  with:
    module-path: pkg/mymodule
    go-version: '1.23'
    tag: v1.5.0
    run-tests: true
    run-linters: true
    goreleaser-config: .goreleaser.custom.yml
    goreleaser-args: --timeout 30m
    release-notes: |
      ## What's Changed
      - Added new feature X
      - Fixed bug Y
      - Performance improvements
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

| Input               | Description                      | Required | Default               |
| ------------------- | -------------------------------- | -------- | --------------------- |
| `module-path`       | Path to Go module                | No       | `.`                   |
| `go-version`        | Go version to use                | No       | `1.23`                |
| `tag`               | Release tag (e.g., v1.2.3)       | Yes      | -                     |
| `is-sdk`            | Enable SDK-specific tagging      | No       | `false`               |
| `sdk-language`      | SDK language identifier          | No       | -                     |
| `run-tests`         | Run tests before release         | No       | `true`                |
| `run-linters`       | Run linters before release       | No       | `true`                |
| `create-release`    | Create GitHub release            | No       | `true`                |
| `release-notes`     | Custom release notes             | No       | -                     |
| `goreleaser-config` | Path to .goreleaser.yml config   | No       | `.goreleaser.yml`     |
| `goreleaser-args`   | Additional GoReleaser arguments  | No       | -                     |
| `skip-publish`      | Skip publishing (use --snapshot) | No       | `false`               |
| `github-token`      | GitHub token                     | No       | `${{ github.token }}` |

## Outputs

| Output        | Description                          |
| ------------- | ------------------------------------ |
| `tag`         | The tag that was created             |
| `sdk-tag`     | The SDK-specific tag (if applicable) |
| `release-url` | URL of the created release           |
| `artifacts`   | List of artifacts created            |

## Examples

### Root Module Release

```yaml
- uses: jdfalk/release-go-action@v1
  with:
    tag: v1.0.0
```

### Nested Module Release

For a repository with structure:

```
.
├── go.mod (main)
├── pkg/
│   ├── auth/
│   │   └── go.mod
│   └── storage/
│       └── go.mod
```

```yaml
- uses: jdfalk/release-go-action@v1
  with:
    module-path: pkg/auth
    tag: v1.0.0
```

This creates tag: `pkg/auth/v1.0.0`

### SDK Release with Dual Tagging

```yaml
- uses: jdfalk/release-go-action@v1
  with:
    module-path: sdk/go
    tag: v2.1.0
    is-sdk: true
    sdk-language: go
```

This creates both:

- `sdk/go/v2.1.0` (module tag)
- `go/v2.1.0` (SDK tag)

### Skip Tests and Linters

```yaml
- uses: jdfalk/release-go-action@v1
  with:
    tag: v1.0.0
    run-tests: false
    run-linters: false
```

### Custom Release Notes

```yaml
- uses: jdfalk/release-go-action@v1
  with:
    tag: v1.0.0
    release-notes: |
      ## 🎉 Features
      - New authentication system
      - Improved error handling

      ## 🐛 Bug Fixes
      - Fixed memory leak in worker pool

      ## ⚠️ Breaking Changes
      - Renamed `Config` to `Settings`
```

## How It Works

1. **Setup**: Configures Go environment with specified version
2. **Validation**: Verifies go.mod exists in the module path
3. **Testing**: Runs tests with race detector and coverage (optional)
4. **Linting**: Runs `go vet` and `golangci-lint` if available (optional)
5. **Tagging**: Creates appropriate tags:
   - Module path tag: `{module-path}/{tag}` for nested modules
   - SDK tag: `{sdk-language}/{tag}` for SDK modules
6. **GoReleaser**: Builds binaries, creates archives, generates checksums
7. **Release**: Creates GitHub release with artifacts and notes

## GoReleaser Configuration

This action uses GoReleaser for building and releasing. You need a
`.goreleaser.yml` file in your repository.

### Example Configuration

See [.goreleaser.example.yml](.goreleaser.example.yml) for a complete example.

Basic `.goreleaser.yml`:

```yaml
before:
  hooks:
    - go mod tidy

builds:
  - main: ./cmd/myapp
    binary: myapp
    env:
      - CGO_ENABLED=0
    goos:
      - linux
      - darwin
      - windows
    goarch:
      - amd64
      - arm64

archives:
  - format: tar.gz
    format_overrides:
      - goos: windows
        format: zip

checksum:
  name_template: 'checksums.txt'

changelog:
  sort: asc
```

### Without GoReleaser

If you don't have a `.goreleaser.yml` file, GoReleaser will use sensible
defaults. However, for production use, we recommend creating a custom
configuration.

## Tag Format

| Scenario      | Tag Format             | Example                       |
| ------------- | ---------------------- | ----------------------------- |
| Root module   | `{tag}`                | `v1.0.0`                      |
| Nested module | `{module-path}/{tag}`  | `pkg/auth/v1.0.0`             |
| SDK module    | `{sdk-language}/{tag}` | `go/v2.0.0`                   |
| SDK + nested  | Both tags created      | `sdk/go/v1.0.0` + `go/v1.0.0` |

## License

MIT

## Contributing

Contributions are welcome! Please open an issue or PR. GitHub Action for
releasing Go modules with SDK support
