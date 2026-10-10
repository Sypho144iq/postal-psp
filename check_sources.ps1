$lines = Get-Content 'Makefile.psp'
$objs = @()
foreach ($line in $lines) {
    $trimmed = $line.Trim().TrimEnd('\').Trim()
    if ($trimmed.EndsWith('.o')) {
        $objs += $trimmed
    }
}

$mismatches = @()
foreach ($obj in $objs) {
    $base = $obj.Substring(0, $obj.Length - 2)
    $targetFile = $null
    if (Test-Path "$base.cpp") { $targetFile = "$base.cpp" }
    elseif (Test-Path "$base.c") { $targetFile = "$base.c" }

    if ($targetFile) {
        # Check casing of each component
        $parts = $targetFile -split '[/\\]'
        $curPath = "."
        foreach ($part in $parts) {
            $items = Get-ChildItem -Path $curPath -ErrorAction SilentlyContinue | Where-Object { $_.Name -ieq $part }
            if ($items) {
                $actualName = $items.Name
                if ($actualName -cne $part) {
                    $mismatches += "$targetFile -> Part '$part' on disk is actually '$actualName'"
                }
                $curPath = Join-Path $curPath $actualName
            }
        }
    }
}

if ($mismatches.Count -gt 0) {
    Write-Output "CASE MISMATCHES FOUND (Breaks Linux build):"
    $mismatches | ForEach-Object { Write-Output "  $_" }
} else {
    Write-Output "All path casings match exactly with disk!"
}
