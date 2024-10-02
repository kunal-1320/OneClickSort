# Save this as sort_files.ps1

# Define file categories
$categories = @{
    Documents = @('.doc', '.docx', '.pdf', '.txt', '.rtf', '.odt', '.xls', '.xlsx', '.ppt', '.pptx', '.csv', '.odp', '.ods')
    Images = @('.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.svg', '.raw', '.cr2', '.nef')
    Videos = @('.mp4', '.avi', '.mkv', '.mov', '.wmv', '.flv', '.webm', '.m4v', '.mpg', '.mpeg', '.3gp')
    Music = @('.mp3', '.wav', '.flac', '.aac', '.ogg', '.m4a', '.wma', '.alac', '.ape', '.opus', '.mid', '.midi')
    Archives = @('.zip', '.rar', '.7z', '.tar', '.gz', '.bz2', '.xz', '.iso')
    Executables = @('.exe', '.msi', '.bat', '.cmd', '.sh', '.app', '.apk', '.deb', '.rpm')
    Code = @('.c', '.cpp', '.h', '.hpp', '.java', '.py', '.js', '.html', '.css', '.php', '.rb', '.go', '.rs', '.swift', '.kt', '.ts', '.sql', '.json', '.xml')
}

# Get all files in the current directory
$files = Get-ChildItem -File

foreach ($file in $files) {
    # Skip the script file itself
    if ($file.Name -eq $MyInvocation.MyCommand.Name) { continue }

    $categorized = $false

    foreach ($category in $categories.Keys) {
        if ($categories[$category] -contains $file.Extension.ToLower()) {
            # Create category folder if it doesn't exist
            if (-not (Test-Path $category)) {
                New-Item -ItemType Directory -Name $category | Out-Null
            }

            # Move file to category folder
            try {
                Move-Item $file.FullName -Destination $category -ErrorAction Stop
                Write-Host "Moved $($file.Name) to $category folder"
                $categorized = $true
                break
            }
            catch {
                Write-Host "Failed to move $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }

    if (-not $categorized) {
        # Move to 'Other' folder if not categorized
        if (-not (Test-Path "Other")) {
            New-Item -ItemType Directory -Name "Other" | Out-Null
        }
        try {
            Move-Item $file.FullName -Destination "Other" -ErrorAction Stop
            Write-Host "Moved $($file.Name) to Other folder"
        }
        catch {
            Write-Host "Failed to move $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "File sorting complete!" -ForegroundColor Green
Read-Host "Press Enter to exit"