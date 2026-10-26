$ErrorActionPreference = "Stop"
Get-Content .\Dockerfile | docker run --rm -i -e HADOLINT_FAILURE_THRESHOLD=error hadolint/hadolint
if ($LASTEXITCODE -ne 0) { exit 1 }