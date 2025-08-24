$backendPath = "C:\Users\Julimore\Pictures\Screenshots\mine\resource-guardian-app\backend\src\main\java"

# Get all Java files
$javaFiles = Get-ChildItem -Path $backendPath -Filter "*.java" -Recurse

Write-Host "Fixing package declarations and imports in $($javaFiles.Count) Java files..."

foreach ($file in $javaFiles) {
  $content = Get-Content $file.FullName -Raw
    
  # Fix package declarations
  $content = $content -replace "package main\.java\.com\.resourceguardian", "package com.resourceguardian"
    
  # Fix import statements
  $content = $content -replace "import main\.java\.com\.resourceguardian", "import com.resourceguardian"
    
  # Write back to file
  Set-Content -Path $file.FullName -Value $content -NoNewline
    
  Write-Host "Fixed: $($file.Name)"
}

Write-Host "All Java files have been fixed!"
Write-Host "You can now rebuild the project."
