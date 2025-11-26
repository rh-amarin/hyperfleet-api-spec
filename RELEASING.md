# Release Process

This document describes how to create a new release of the HyperFleet API specification.

## Prerequisites

- Write access to the openshift-hyperfleet/hyperfleet-api-spec repository
- GitHub CLI (`gh`) installed and authenticated (optional, can use web UI instead)
- Clean working tree with all changes committed

## Versioning Strategy

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version: Incompatible API changes (breaking changes)
- **MINOR** version: Backward-compatible functionality additions
- **PATCH** version: Backward-compatible bug fixes

Examples:
- Breaking change (removed endpoint, changed required field): `v1.0.0` → `v2.0.0`
- New endpoint added: `v1.0.0` → `v1.1.0`
- Documentation fix, typo correction: `v1.0.0` → `v1.0.1`

## Release Steps

### 1. Prepare the Release

Ensure both OpenAPI specifications are built and committed:

```bash
# Build both specifications
./build-schema.sh core
./build-schema.sh gcp

# Review changes
git status
git diff schemas/

# Commit if needed
git add schemas/
git commit -m "Update OpenAPI schemas for vX.Y.Z release"
git push origin main
```

### 2. Create and Push Tag

```bash
# Create annotated tag
git tag -a vX.Y.Z -m "$(cat <<'EOF'
Release vX.Y.Z - Brief description

Detailed release notes:
- Feature 1
- Feature 2
- Bug fix 1
EOF
)"

# Push tag to upstream
git push upstream vX.Y.Z
```

### 3. Prepare Release Assets

Copy the OpenAPI files with descriptive names:

```bash
cp schemas/core/openapi.yaml /tmp/core-openapi.yaml
cp schemas/gcp/openapi.yaml /tmp/gcp-openapi.yaml
```

### 4. Create GitHub Release

#### Option A: Using GitHub CLI (Recommended)

```bash
gh release create vX.Y.Z \
  --repo openshift-hyperfleet/hyperfleet-api-spec \
  --title "vX.Y.Z - Release Title" \
  --notes-file release-notes.md \
  /tmp/core-openapi.yaml \
  /tmp/gcp-openapi.yaml
```

#### Option B: Using GitHub Web UI

1. Go to https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/new
2. Select the tag `vX.Y.Z`
3. Fill in title and description (use template below)
4. Upload `core-openapi.yaml` and `gcp-openapi.yaml` from `/tmp/`
5. Ensure "Set as the latest release" is checked
6. Click "Publish release"

### 5. Verify Release

```bash
# View release details
gh release view vX.Y.Z --repo openshift-hyperfleet/hyperfleet-api-spec

# Test download URLs
curl -L -I https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/core-openapi.yaml
curl -L -I https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/gcp-openapi.yaml

# Download and verify content
curl -L https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/core-openapi.yaml -o /tmp/verify-core.yaml
diff /tmp/verify-core.yaml schemas/core/openapi.yaml
```

### 6. Announce Release

- Notify consumers and stakeholders
- Update documentation links if needed

## Release Notes Template

Use this template for release notes:

```markdown
# HyperFleet API Specification vX.Y.Z

Brief description of this release.

## What's New

### Features
- New feature 1
- New feature 2

### Bug Fixes
- Bug fix 1
- Bug fix 2

### Breaking Changes (if applicable)
- Breaking change 1 with migration instructions
- Breaking change 2 with migration instructions

## Consuming the API Specifications

### Always get the latest stable version:
```bash
# Core API
curl -L -O https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/core-openapi.yaml

# GCP API
curl -L -O https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/gcp-openapi.yaml
```

### Download this specific version (vX.Y.Z):
```bash
# Core API
curl -L -O https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/download/vX.Y.Z/core-openapi.yaml

# GCP API
curl -L -O https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/download/vX.Y.Z/gcp-openapi.yaml
```

## Documentation

- **Interactive API Documentation**: https://openshift-hyperfleet.github.io/hyperfleet-api-spec/
- **Repository**: https://github.com/openshift-hyperfleet/hyperfleet-api-spec
- **README**: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/blob/main/README.md

---

🤖 Generated with HyperFleet Release Automation
```

## URL Formats Reference

### Latest Release (Always points to newest)
- Core: `https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/core-openapi.yaml`
- GCP: `https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/gcp-openapi.yaml`

### Specific Version
- Core: `https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/download/vX.Y.Z/core-openapi.yaml`
- GCP: `https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/download/vX.Y.Z/gcp-openapi.yaml`

## Quick Release Checklist

Use this checklist for each release:

- [ ] Build schemas: `./build-schema.sh core && ./build-schema.sh gcp`
- [ ] Commit schema changes (if any)
- [ ] Create and push tag: `git tag -a vX.Y.Z -m "..." && git push upstream vX.Y.Z`
- [ ] Prepare assets: `cp schemas/*.yaml /tmp/`
- [ ] Create GitHub Release (gh CLI or web UI)
- [ ] Upload `core-openapi.yaml` and `gcp-openapi.yaml`
- [ ] Verify "latest" badge appears on release
- [ ] Test latest download URLs
- [ ] Announce release to stakeholders

## Troubleshooting

### Issue: "latest" URL returns older version

**Cause**: GitHub determines "latest" by semantic versioning, not chronological order

**Solution**:
1. Ensure new version number is higher: v1.0.0 < v1.1.0 < v2.0.0
2. Manually mark release as latest in GitHub UI if needed
3. Check that release is not marked as "pre-release"

### Issue: Asset upload fails

**Cause**: File size limits, network issues, or permission problems

**Solution**:
1. Check file size (GitHub has 2GB asset limit)
2. Verify repository write permissions
3. Re-authenticate with `gh auth login`
4. Try uploading via GitHub web UI as alternative

### Issue: URLs return 404

**Cause**: File name mismatch or release not published

**Solution**:
1. Verify exact file names (case-sensitive)
2. Check release is published (not draft)
3. Confirm tag exists: `git ls-remote --tags upstream`
4. Wait a few minutes for GitHub CDN propagation

### Issue: Tag not appearing

```bash
# Verify tag exists locally
git tag -l | grep vX.Y.Z

# Push tag to upstream
git push upstream vX.Y.Z

# Verify tag on remote
git ls-remote --tags upstream | grep vX.Y.Z
```

## Automation Opportunities

Consider implementing GitHub Actions workflow for automated releases in `.github/workflows/release.yml`:

```yaml
name: Create Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm install

      - name: Build Core schema
        run: ./build-schema.sh core

      - name: Build GCP schema
        run: ./build-schema.sh gcp

      - name: Prepare release assets
        run: |
          cp schemas/core/openapi.yaml core-openapi.yaml
          cp schemas/gcp/openapi.yaml gcp-openapi.yaml

      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: |
            core-openapi.yaml
            gcp-openapi.yaml
          draft: false
          prerelease: false
          generate_release_notes: true
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

This workflow automatically:
1. Triggers on tag push
2. Builds both schemas
3. Creates release with auto-generated notes
4. Uploads assets

## Security Best Practices

1. **Authentication**: Use GitHub Apps or fine-grained personal access tokens for automation
2. **File Integrity**: Include checksums (SHA-256) in release notes
3. **Versioning Discipline**: Never delete or modify published releases
4. **Pre-releases**: Use pre-release tags for testing (v1.0.0-rc1, v1.0.0-beta.1)
5. **GPG Signing**: Consider signing releases for high-security environments
