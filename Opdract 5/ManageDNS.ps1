#taak 2
#maak een reverse lookupzone non activedirectory integrated
Add-DnsServerPrimaryZone -NetworkId "192.168.5.0/24" -ZoneFile "5.168.192.in-addr.arpa.dns"

#wijzig SOA voor tcr-coehod.int
$OldObj = Get-DnsServerResourceRecord -ZoneName "tcr-coehod.int" -RRType "SOA" -name "@"
$newobj = $OldObj.Clone()
$newobj.RecordData.MinimumTimeToLive = New-TimeSpan -Minutes 30
$newobj.RecordData.RefreshInterval = New-TimeSpan -Hours 1
$newobj.RecordData.RetryDelay = New-TimeSpan -Minutes 15
$newobj.RecordData.ExpireLimit = New-TimeSpan -Days 2

Set-DnsServerResourceRecord -OldInputObject $OldObj -NewInputObject $newobj -ZoneName tcr-coehod.int

#wijzig SOA voor 5.168.192.in-addr.arpa
$OldObj = Get-DnsServerResourceRecord -ZoneName 5.168.192.in-addr.arpa -RRType "SOA" -name "@"
$newobj = $OldObj.Clone()
$newobj.RecordData.MinimumTimeToLive = New-TimeSpan -Minutes 30
$newobj.RecordData.RefreshInterval = New-TimeSpan -Hours 1
$newobj.RecordData.RetryDelay = New-TimeSpan -Minutes 15
$newobj.RecordData.ExpireLimit = New-TimeSpan -Days 2

Set-DnsServerResourceRecord -OldInputObject $OldObj -NewInputObject $newobj -ZoneName 5.168.192.in-addr.arpa

#dynamicupdate nonsecure and secure
Set-DnsServerPrimaryZone -Name tcr-coehod.int -DynamicUpdate NonsecureAndSecure
Set-DnsServerPrimaryZone -Name 5.168.192.in-addr.arpa -DynamicUpdate NonsecureAndSecure

#controleer of het allemaal goed gegaan is
Get-DnsServerZone | Format-Table -AutoSize

#taak 3
#toevoegen van hostrecords
Add-DnsServerResourceRecordA -Name webmail -ZoneName tcr-coehod.int -IPv4Address 192.168.5.1
Add-DnsServerResourceRecordA -Name ftp1 -ZoneName tcr-coehod.int -IPv4Address 192.168.5.1
#laat het zien
Get-DnsServerResourceRecord -ZoneName tcr-coehod.int -RRType A

#maak een koppeling (alias, cname)
Add-DnsServerResourceRecordCName -ZoneName tcr-coehod.int -HostNameAlias "dc1.tcr-coehod.int" -Name "www"
Get-DnsServerResourceRecord -ZoneName tcr-coehod.int -RRType CName

#maak een mx record
Add-DnsServerResourceRecordMX -Preference 10  -Name "." -TimeToLive 01:00:00 -MailExchange smtp.tcr-coehod.int -ZoneName tcr-coehod.int
#Laat het zien
Get-DnsServerResourceRecord -ZoneName xyz.int -RRType "MX"

#taak 8
#Voeg forwarders toe
Set-DnsServerForwarder -IPAddress 10.60.3.223, 8.8.8.8

