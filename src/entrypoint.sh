#!/usr/bin/env bash
# file: src/entrypoint.sh
# version: 1.0.0
# guid: 2c4b6d8f-1a3e-4c5d-9f7a-0b1c2d3e4f5a

set -euo pipefail

MODULE_PATH=${MODULE_PATH:-.}
GO_VERSION=${GO_VERSION:-1.24}
TAG_INPUT=${TAG_INPUT:-}
IS_SDK=${IS_SDK:-false}
SDK_LANGUAGE=${SDK_LANGUAGE:-}
RUN_TESTS=${RUN_TESTS:-true}
RUN_LINTERS=${RUN_LINTERS:-true}
CREATE_RELEASE=${CREATE_RELEASE:-true}
RELEASE_NOTES=${RELEASE_NOTES:-}
GORELEASER_CONFIG=${GORELEASER_CONFIG:-.goreleaser.yml}
GORELEASER_ARGS=${GORELEASER_ARGS:-}
SKIP_PUBLISH=${SKIP_PUBLISH:-false}
GITHUB_TOKEN=${GITHUB_TOKEN:-}

cd "$MODULE_PATH"

echo "Setting Go version $GO_VERSION (docker image already matches)"

if [ -z "$TAG_INPUT" ]; then
  echo "::error::TAG_INPUT is required"
  exit 1
fi

if [ "$RUN_TESTS" = "true" ]; then
  go test -v -race -coverprofile=coverage.out ./...
  go tool cover -func=coverage.out
fi

if [ "$RUN_LINTERS" = "true" ]; then
  go vet ./...
  if command -v golangci-lint >/dev/null 2>&1; then
    golangci-lint run
  fi
fi

TAG="$TAG_INPUT"
if [ "$MODULE_PATH" != "." ]; then
  TAG="${MODULE_PATH}/${TAG_INPUT}"
fi

SDK_TAG=""
if [ "$IS_SDK" = "true" ] && [ -n "$SDK_LANGUAGE" ]; then
  SDK_TAG="${SDK_LANGUAGE}/${TAG_INPUT}"
fi

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

if [ "$CREATE_RELEASE" = "true" ]; then
  if ! git rev-parse "$TAG" >/dev/null 2>&1; then
    git tag -a "$TAG" -m "Release $TAG"
    git push origin "$TAG" || echo "Warning: Failed to push tag (may already exist remotely)"
  else
    echo "Tag $TAG already exists, skipping creation"
  fi

  if [ -n "$SDK_TAG" ]; then
    if ! git rev-parse "$SDK_TAG" >/dev/null 2>&1; then
      git tag -a "$SDK_TAG" -m "SDK Release $SDK_TAG"
      git push origin "$SDK_TAG" || echo "Warning: Failed to push SDK tag"
    else
      echo "SDK tag $SDK_TAG already exists, skipping creation"
    fi
  fi
fi

ARGS="release --clean"
if [ "$SKIP_PUBLISH" = "true" ]; then
  ARGS="$ARGS --snapshot"
fi
if [ -n "$GORELEASER_ARGS" ]; then
  ARGS="$ARGS $GORELEASER_ARGS"
fi

goreleaser "$ARGS" --config "$GORELEASER_CONFIG"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  printf 'tag=%s\n' "$TAG" >>"$GITHUB_OUTPUT"
  printf 'sdk-tag=%s\n' "$SDK_TAG" >>"$GITHUB_OUTPUT"
  printf 'url=\n' >>"$GITHUB_OUTPUT"
fi

if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  {
    echo "## Go Module Release Summary"
    echo ""
    echo "**Module Path:** ${MODULE_PATH}"
    echo "**Tag:** ${TAG}"
    if [ -n "$SDK_TAG" ]; then
      echo "**SDK Tag:** ${SDK_TAG}"
    fi
    echo "**Go Version:** ${GO_VERSION}"
  } >>"$GITHUB_STEP_SUMMARY"
fi
