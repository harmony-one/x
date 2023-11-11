#!/bin/sh
if git diff --cached --name-only | grep --quiet "AppConfig.plist"; then
  echo "Error: Commit contains AppConfig.plist, which is not allowed."
  exit 1
fi
