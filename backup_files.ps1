$Date = (Get-Date).AddDays(-3)
Get-ChildItem -Path D:\test\1111 | where {!$_.PSIsContainer} |
foreach {
   if ($_.LastWriteTime -lt $Date) 
   {
     & "C:\Program Files\7-Zip\7z.exe" a ("$D:\test\222\arch\" + $Day.ToString("yyyyMM") + ".7z") $_.FullName
   }
}