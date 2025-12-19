<!-- file: TODO.md -->
<!-- version: 1.1.0 -->
<!-- guid: 12345678-1234-1234-1234-123456789006 -->

# TODO - release-go-action

## Recent Changes

### ✅ Implemented GoReleaser Integration
**Status:** Complete
**Date:** 2025-12-19

**Changes:**
- Migrated from manual builds to GoReleaser-based releases
- Added GoReleaser configuration support
- Updated action.yml with new inputs (goreleaser-config, goreleaser-args, skip-publish)
- Created .goreleaser.example.yml template
- Updated README.md with GoReleaser documentation
- Added artifacts output

**Benefits:**
- Professional-grade releases with cross-compilation
- Automatic archive creation and checksums
- Better changelog generation
- Standard Go ecosystem approach
- Reduced maintenance burden

---

## CI/CD Status

### #todo Fix CI Test Failures
**Status:** In Progress
**Priority:** Critical

**Current Issues:**
- CI tests may need GoReleaser config to pass
- Need to verify all tests work with new GoReleaser approach

**Next Steps:**
1. Monitor CI test runs
2. Add sample .goreleaser.yml for testing
3. Update test workflows if needed

---

## Migration Tasks

### #todo Update Documentation Examples
**Status:** Pending
**Priority:** Medium

**Tasks:**
- Add more GoReleaser configuration examples
- Document common build scenarios
- Add troubleshooting section for GoReleaser
- Document migration from manual builds

### #todo Migrate to Reusable Workflows
**Status:** Pending
**Priority:** Low
**Dependencies:** CI must pass first

**Description:**
After implementing the action and fixing CI, migrate to use centralized reusable workflows:
- `.github/workflows/reusable-action-ci.yml`
- `.github/workflows/reusable-release.yml`

**Tasks:**
1. Verify action works with GoReleaser
2. Fix all CI failures
3. Update workflow to call reusable workflow
4. Test workflows thoroughly
5. Document migration

---

## Testing Requirements

### #todo Comprehensive Testing
**Status:** Pending
**Priority:** High

**Required Tests:**
1. Test with basic .goreleaser.yml
2. Test without .goreleaser.yml (defaults)
3. Test multi-module repositories
4. Test SDK tagging
5. Test with custom GoReleaser config
6. Test snapshot builds (skip-publish)
7. Test release creation

**Test Coverage:**
- [ ] Single module builds
- [ ] Multi-module repositories
- [ ] SDK tagging scenarios
- [ ] Custom GoReleaser configurations
- [ ] Different Go versions (1.21, 1.22, 1.23)
- [ ] Cross-platform builds via GoReleaser
- [ ] Archive formats (tar.gz, zip)
- [ ] Checksum generation
- [ ] Release asset upload
- [ ] Changelog generation

---

## Enhancement Opportunities

### #todo GoReleaser Advanced Features
**Status:** Pending
**Priority:** Low

**Potential Enhancements:**
1. Support for GoReleaser Pro features
2. Docker image builds
3. Homebrew tap support
4. Snapcraft support
5. Binary signing configuration
6. SBOM generation via GoReleaser
7. Custom hook support
8. Build matrix optimization

---

**Last Updated:** 2025-12-19
**Next Review:** After CI passes
**Critical Path:** Fix CI → Complete testing → Add advanced features
