$ErrorActionPreference = "Stop"
if (!(Test-Path "reports")) { New-Item -ItemType Directory -Path "reports" | Out-Null }
trivy image --format cyclonedx --output reports/sbom-lab243.json lab243:1.0.0
if ($LASTEXITCODE -ne 0) { exit 1 }