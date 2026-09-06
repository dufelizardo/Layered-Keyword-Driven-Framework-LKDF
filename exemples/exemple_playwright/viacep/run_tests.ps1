# Runs this example's suite from its own directory, regardless of where this script is invoked
# from - avoids `npx` falling back to a mismatched globally-cached @playwright/test copy when run
# from a folder with no local install (see repo history for what that looks like).
param([string[]]$PlaywrightArgs)
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $here
try {
    npx playwright test @PlaywrightArgs
} finally {
    Pop-Location
}
