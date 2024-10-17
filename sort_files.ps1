# Save this as sort_files.ps1

# Define common file categories
$categories = @{
    "Compressed Files" = @('.zip', '.rar', '.7z', '.tar', '.gz', '.bz2', '.xz')
    "Images" = @('.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.svg', '.webp')
    "Videos" = @('.mp4', '.avi', '.mkv', '.mov', '.wmv', '.flv', '.webm', '.m4v', '.mpg', '.mpeg')
    "Audio" = @('.mp3', '.wav', '.flac', '.aac', '.ogg', '.m4a', '.wma', '.opus')
    "Documents" = @('.doc', '.docx', '.pdf', '.txt', '.rtf', '.odt', '.xls', '.xlsx', '.ppt', '.pptx', '.csv')
    "Executables" = @('.exe', '.msi', '.bat', '.cmd', '.sh', '.app')
    "Code" = @('.c', '.cpp', '.h', '.java', '.py', '.js', '.html', '.css', '.php', '.rb', '.go', '.ts', '.sql')
}

# Get the script's directory
$scriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Change to the script's directory
Set-Location $scriptDir

# Get all files in the current directory (excluding subdirectories and .lnk files)
$files = Get-ChildItem -File | Where-Object { $_.Extension -ne '.lnk' }

# Create a hashtable for quick extension lookup
$extensionMap = @{}
foreach ($category in $categories.Keys) {
    foreach ($extension in $categories[$category]) {
        $extensionMap[$extension] = $category
    }
}

foreach ($file in $files) {
    # Skip the script file itself
    if ($file.Name -eq $MyInvocation.MyCommand.Name) { continue }
    
    $extension = $file.Extension.ToLower()
    
    # Determine the category or use the extension as folder name
    $category = $extensionMap[$extension]
    if (-not $category) {
        $category = $extension.TrimStart('.')
        if ($category -eq '') {
            $category = "NoExtension"
        }
    }
    
    $destination = Join-Path $scriptDir $category
    
    # Create folder if it doesn't exist
    if (-not (Test-Path $destination)) {
        New-Item -ItemType Directory -Path $destination | Out-Null
    }
    
    # Move file to its corresponding folder
    try {
        Move-Item $file.FullName -Destination $destination -ErrorAction Stop
        Write-Host "Moved $($file.Name) to $category folder" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to move $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nFile sorting complete!" -ForegroundColor Green
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
