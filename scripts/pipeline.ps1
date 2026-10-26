$ErrorActionPreference = "Stop"
$IMAGE = "lab243:1.0.0"

if (!(Test-Path "reports")) { New-Item -ItemType Directory -Path "reports" | Out-Null }

Write-Host "=== 1. Lint del Dockerfile ==="
Get-Content .\Dockerfile | docker run --rm -i -e HADOLINT_FAILURE_THRESHOLD=error hadolint/hadolint
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "=== 2. Build de la imagen ==="
docker build -t $IMAGE .
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "=== 3. Escaneo de vulnerabilidades ==="
trivy image `
    --severity HIGH,CRITICAL `
    --exit-code 1 `
    $IMAGE
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "=== 4. Escaneo de secretos ==="
trivy fs `
    --scanners secret `
    --exit-code 1 `
    .
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "=== 5. Generación de SBOM ==="
trivy image `
    --format cyclonedx `
    --output reports/sbom-lab243.json `
    $IMAGE
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "=== Pipeline local completado con éxito ==="