#!/bin/bash
set -euo pipefail

xcodebuild test \
  -project CommandForJapanese.xcodeproj \
  -scheme CommandForJapanese \
  -destination 'platform=macOS'
