##############################################################################
#������ �������� ���������� ����� �� �� �� ������� ������.                   #
#���������, �������� ����� �� �������� ����� � ������������ ��������.        #
#Aleksandr Yakunin   				                      				     #
##############################################################################

###########################���� ����������##############################

#��� ������ ���� �� �����.
 $log = "E:\log\logstart.txt"
 $datelog = [datetime]::Parse((gc $log))

#������ ���� �� ����������
 $Dirnew = "\\10.0.0.2\nksh\CBRF\IN"
 $Dirold = "C:\MCI\IN"
 $DirED = "\\10.1.0.56\armkbr\income"

#����� ��� ���������� ��� ��������� ������ � ������.
 $excED = @('*.ED', '*.EDS', '*.ED.renamed*', '*.EDS.renamed*') 
 $incED = @('*.ED', '*.EDS', '*.ED.renamed*', '*.EDS.renamed*')
 
###################################���� �������##########################

#��������� ���������� � �������� ����� ��� ������� �� ����.
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

#�������� ����� ED, EDS � incom.
Get-ChildItem -Path $Dirold -Recurse -Include $incED | Where-Object {$_.PSIsContainer -eq $false -and $_.LastWriteTime -gt "$datelog"} | ForEach-Object { Copy-Item $_.FullName $DirED}
   
    
#������� ��������� ����� ����c�� �������
[system.DateTime]::Now > $log