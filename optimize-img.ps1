param(
    [Parameter(Mandatory, HelpMessage="URL de la imagen (ej: https://images.unsplash.com/photo-XXXX)")]
    [string]$Url,
    [Parameter(Mandatory, HelpMessage="Nombre del archivo (ej: carrusel4.jpg)")]
    [string]$FileName,
    [Parameter(HelpMessage="Ancho en píxeles (default: 1200 para carrusel, 800 para tarjetas)")]
    [int]$Width = 1200,
    [Parameter(HelpMessage="Calidad 1-100 (default: 60)")]
    [int]$Quality = 60
)

$imgDir = Join-Path $PSScriptRoot "img"
$output = Join-Path $imgDir $FileName

Write-Output "Descargando $FileName ..."

# Limpiar parámetros existentes de la URL y añadir los nuestros
$baseUrl = $Url -replace '\?.*$', ''
$downloadUrl = "$baseUrl`?w=$Width&q=$Quality"

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $output -UseBasicParsing
    $file = Get-Item $output
    $sizeKB = [math]::Round($file.Length / 1KB)
    
    if ($file.Length -le 200KB) {
        Write-Output "OK: $sizeKB KB (<200KB) - $output"
    } else {
        Write-Output "AVISO: $sizeKB KB (supera 200KB). Prueba con -Quality menor o -Width menor"
    }
} catch {
    Write-Output "ERROR: $_"
}
