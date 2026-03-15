$env:JAVA_HOME = "C:\Program Files\Java\jdk-21"
$mvn = "C:\Program Files\NetBeans-27\netbeans\java\maven\bin\mvn.cmd"
& $mvn compile 2>&1 | Out-File -FilePath "mvn_compile_out.txt" -Encoding utf8
Write-Host "Exit: $LASTEXITCODE"
Get-Content "mvn_compile_out.txt" | Select-Object -Last 30
