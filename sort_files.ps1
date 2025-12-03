# --- SORT BY EXTENSION (jpg folder, pdf folder, etc.) ---

# Get the current directory (The folder you right-clicked in)
$currentDir = Get-Location
Write-Host "Sorting by extension in: $currentDir" -ForegroundColor Cyan

# Files to ALWAYS ignore
$ignoredFiles = @('sort_files.ps1', 'Run_Sorter.bat')

# Get all files in the CURRENT directory
$files = Get-ChildItem -LiteralPath $currentDir -File | Where-Object { $_.Extension -ne '.lnk' -and $_.Name -notin $ignoredFiles }

if ($files.Count -eq 0) {
    Write-Host "No files found to sort." -ForegroundColor Yellow
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Exit
}

$counter = 0
foreach ($file in $files) {
    $counter++
    $percent = [math]::Round(($counter / $files.Count) * 100)
    Write-Progress -Activity "Sorting Files..." -Status "Moving $($file.Name)" -PercentComplete $percent

    # Get extension (e.g., ".jpg") and remove the dot (e.g., "jpg")
    $extension = $file.Extension.TrimStart('.').ToLower()
    
    # Handle files with no extension
    if ([string]::IsNullOrWhiteSpace($extension)) {
        $folderName = "No_Extension"
    } else {
        $folderName = $extension
    }

    $destFolder = Join-Path $currentDir $folderName
    
    # Create folder if it doesn't exist (e.g., "C:\Users\...\Documents\jpg")
    if (-not (Test-Path $destFolder)) {
        New-Item -ItemType Directory -Path $destFolder | Out-Null
    }

    $destPath = Join-Path $destFolder $file.Name

    # HANDLE DUPLICATES (If file already exists, rename it)
    if (Test-Path $destPath) {
        $i = 1
        $baseName = $file.BaseName
        do {
            $newName = "$baseName ($i).$extension"
            $destPath = Join-Path $destFolder $newName
            $i++
        } while (Test-Path $destPath)
    }

    try {
        Move-Item $file.FullName -Destination $destPath -ErrorAction Stop
    }
    catch {
        Write-Host "Error moving $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Progress -Activity "Sorting Files..." -Completed
Write-Host "Done! Sorted $($files.Count) files into extension folders." -ForegroundColor Green
Start-Sleep -Seconds 2
