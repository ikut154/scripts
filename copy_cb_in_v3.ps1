##############################################################################
#Скрипт копирует полученные файлы из цб на сетевой ресурс.                   #
#Расширяем, копируем файлы по заданной маске в определенные каталоги.        #
#Aleksandr Yakunin   				                      				     #
##############################################################################

###########################Блок переменных##############################

#Тут парсим дату из файла.
 $log = "E:\log\logstart.txt"
 $datelog = [datetime]::Parse((gc $log))

#Задаем пути до директорий
 $Dirnew = "\\10.0.0.2\nksh\CBRF\IN"
 $Dirold = "C:\MCI\IN"
 $DirED = "\\10.1.0.56\armkbr\income"

#Маски для исключения или включения файлов в поиске.
 $excED = @('*.ED', '*.EDS', '*.ED.renamed*', '*.EDS.renamed*') 
 $incED = @('*.ED', '*.EDS', '*.ED.renamed*', '*.EDS.renamed*')
 
###################################Тело скрипта##########################

#Формируем директорию и копируем файлы для разбора на шаре.
$Files = Get-ChildItem $Dirold -Recurse -Exclude $excED | ? {!$_.PSIsContainer}
foreach ($File in $Files) 
{
    $Day = "0"+$File.LastWriteTime.Day
    $Day = $Day.Substring($Day.Length-2,2)
    $Month = "0"+$File.LastWriteTime.Month
    $Month = $Month.Substring($Month.Length-2,2)
    $Year = $File.LastWriteTime.Year
    $Dest = $Dirnew + "\" + $Year

    If (!(Test-Path $Dest)) 
    {
        New-Item -Path $Dest -ItemType Directory -Force
    }
    $Dest = $Dest + "\" + $Month + "\" + $Day
    
    If (!(Test-Path $Dest)) 
    {
        New-Item -Path $Dest -ItemType Directory -Force
    }
    Copy-Item -Path $File.Fullname -Destination $Dest -Force
}  

#Копируем файлы ED, EDS в incom.
Get-ChildItem -Path $Dirold -Recurse -Include $incED | Where-Object {$_.PSIsContainer -eq $false -and $_.LastWriteTime -gt "$datelog"} | ForEach-Object { Copy-Item $_.FullName $DirED}
   
    
#Сливаем последнее время запуcка скрипта
[system.DateTime]::Now > $log