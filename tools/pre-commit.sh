#!/usr/bin/env bash
# Minimal pre-commit hook example to run swiftformat and swiftlint autocorrect where available.
set -euo pipefail

if command -v swiftformat >/dev/null 2>&1; then
  echo "Running swiftformat..."
  swiftformat . || true
fi

if command -v swiftlint >/dev/null 2>&1; then
  echo "Running swiftlint autocorrect..."
  swiftlint autocorrect || true
fi

echo "Pre-commit hooks finished."
