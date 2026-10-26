$ErrorActionPreference = "Stop"
$IMAGE = "lab243:1.0.0"
$REPORT = "reports/trivy-lab243.json"

if (!(Test-Path "reports")) {
    New-Item -ItemType Directory -Path "reports" | Out-Null
}

trivy image `
    --severity HIGH,CRITICAL `
    --exit-code 1 `
    --format table `
    $IMAGE
if ($LASTEXITCODE -ne 0) { exit 1 }

trivy image `
    --severity HIGH,CRITICAL `
    --format json `
    --output $REPORT `
    $IMAGE
if ($LASTEXITCODE -ne 0) { exit 1 }