$imagepath = "e:\iso\WindowsServer2022Evaluation.iso"
#Verkrijg de driveletter van de virtuele dvd drive
$DriveLetter = (mount-diskimage -path $ImagePath -PassThru | get-volume).DriveLetter
#kopieer heel de virtuele dvd naar een locatie
copy-item "$($DriveLetter):\*" -Destination E:\UitgepakteIso\WindowsServer2022\ -Recurse
#Haal readonly van de bestanden
get-childitem * -Recurse -File | ForEach-Object { $_.IsReadOnly=$false }