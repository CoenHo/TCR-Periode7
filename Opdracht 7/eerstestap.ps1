#nadat je een powershell dirct connectie gemaakt hebt voer je volgende commando's uit

#als je de windows server de eerste keer maakt dan is interfacealias altijd ethernet, gebruik je meerdere netwerkkaarten zal je de naam moeten achterhalen
#Dat kan met het commando get-netadapter
New-NetIPAddress -IPAddress 192.168.5.3 -DefaultGateway 192.168.5.254 -PrefixLength 24 -AddressFamily IPv4 -InterfaceAlias Ethernet

#nu moeten we nog de dnsserver invullen
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses '192.168.5.1'

#vervolgens ga je de tijdzone controleren
get-timezonr

#als de tijdzone op W. Europe Standard Time staat is het goed anders moet deze wijzigen
set-timezone -Id 'W. Europe Standard Time'

#om alle tijdzones te laten zien kan je dit gebruiken
get-timezone -ListAvailable

#vervolgend gaan de de computernaam aanpassen
Rename-Computer -NewName DC2-CoeHod2x -Restart

#nu gaan we ipv6 uitzetten
#om alle opties te zien gebruiken we Get-NetAdapterBinding, we zijn echter alleen geinteresseerd in ipv6
Get-NetAdapterBinding -ComponentID ‘ms_tcpip6’

#nu gaan we het uitzetten
get-netadapter | Disable-NetAdapterBinding -ComponentID ‘ms_tcpip6’
#er is geen schermuitvoer als je dat wil zien moet je de parameter -PassThru gebruiken
get-netadapter | Disable-NetAdapterBinding -ComponentID ‘ms_tcpip6’ -PassThru

#ga naar de volgende stap