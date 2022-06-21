#configureer DHCP
Add-DhcpServerInDC -DnsName DC1-CoeHod2x.int -IPAddress 192.168.5.1 -PassThru # -PassThru gebruiken we weer om output te krijgen

#vervolgens maken we de dhcp groepen aan
Add-DhcpServerSecurityGroup #je krijgt geen output!
#op de volgende manier kan je het controleren
Get-ADGroup -Filter * | where-object name -like 'dhcp*'
#nu voegen we de scope toe
Add-DhcpServerv4Scope -SubnetMask 255.255.255.0 -State Active -name TScope-CoeHod -StartRange 192.168.5.200 -EndRange 192.168.5.250 -LeaseDuration 1.00:00:00
#standaarde genereert dit commando geen output, gebruik dus weer -PassThru als je bevestiging wil hebben voor je documentatie
#vervolgens gaan we de opties configureren
Set-DhcpServerv4OptionValue -DnsDomain CoeHod2x.int -DnsServer 192.168.5.1 -Router 192.168.5.254 -PassThru
#voeg reservering toe voor dc2
Add-DhcpServerv4Reservation -IPAddress 192.168.5.3 -ClientId '00155DB2E746' -ScopeId 192.168.5.0 #macadres moet je natuurlijk aanpassen