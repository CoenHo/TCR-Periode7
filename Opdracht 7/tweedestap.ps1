#nu gaan we de rollen instaleren die we nodig hebben
Install-WindowsFeature ad-domain-services, dhcp -IncludeManagementTools

#nu gaan we de domain administrator credentials opslaan in een variabele
$cred = get-credential tcr-coehod\administrator

#en dan gaan we de domaincontroller instalern
Install-ADDSDomainController -DomainName tcr-coehod.int -credential $cred
#er komt een prompt voor safemodeadministratorpassword

#als je dit niet wil kan je onderstaande gebruiken
#Region Optioneel
    
    $password = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
    $smp = New-Object System.Management.Automation.PSCredential ("username", $password)

    Install-ADDSDomainController -DomainName tcr-coehod.int -credential $cred -SafeModeAdministratorPassword $smp.pasword
#EndRegion