$Date = (Get-Date).AddDays(-1)
Get-ChildItem -Path D:\test\1111 | where {!$_.PSIsContainer} |
foreach {
   if ($_.LastWriteTime -lt $Date) {
      # в тестовых целях указываем -whatif
      # когда убедимся что все корректно работает то убираем его
      Remove-Item $_ -whatif
   }
}


