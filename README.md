# File Sorting Script

This PowerShell script **automatically organizes files** in a directory by sorting them into predefined folders based on their file extensions.

##Features:
- **Predefined file categories** (Documents, Images, Videos, Music, Archives, Executables, Code)
- **Automatically creates folders** if they don't exist
- **Error handling** during file movement
- **Fallback to "Other" folder** for uncategorized files
- **Customizable categories**
#NOTE:
** when you right click on any location it will show " organise file here" thing click it and it will sort on that location 
but take care of the location of script and in registry file (c drive ---> Scripts ---> sort_files.ps1)

##  Usage:
1. Place the `sort_files.ps1` script in the directory you want to organize.
2. Run the script in **PowerShell**.
3. The script will sort your files into corresponding folders:
   - **Documents**: `.doc`, `.pdf`, `.xls`, etc.
   - **Images**: `.jpg`, `.png`, `.gif`, etc.
   - **Videos**: `.mp4`, `.avi`, `.mkv`, etc.
   - **Music**: `.mp3`, `.wav`, `.flac`, etc.
   - **Archives**: `.zip`, `.rar`, `.7z`, etc.
   - **Executables**: `.exe`, `.bat`, `.sh`, etc.
   - **Code**: `.py`, `.js`, `.html`, etc.
   - And files that don’t match these categories go into the **Other** folder.

## 💻 Example:
```powershell
PS C:\> .\sort_files.ps1
