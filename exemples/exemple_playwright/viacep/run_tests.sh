#!/usr/bin/env bash
# Runs this example's suite from its own directory, regardless of where this script is invoked
# from - avoids `npx` falling back to a mismatched globally-cached @playwright/test copy when run
# from a folder with no local install (see repo history for what that looks like).
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$here" && npx playwright test "$@"
