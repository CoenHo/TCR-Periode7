#eerst de juiste rollen installeren
Install-WindowsFeature ad-domain-services, dhcp -IncludeManagementTools

#de makkelijke manier is dit
Install-ADDSForest -DomainName TCR-CoeHod.int -ForestMode Win2012R2 -DomainMode Win2012R2
#als je dit commando uitvoert krijg je een prompt voor het safemodepassword

#als je dit niet wil kan je onderstaande gebruiken
#Region Optioneel
    
    $password = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PSCredential ("username", $password)

    #daarna maken we ons eerste forest
    Install-ADDSForest -DomainName TCR-CoeHod.int -ForestMode Win2012R2 -DomainMode Win2012R2 -SafeModeAdministratorPassword $cred.Password
#EndRegion

#ga nu naar de volgende stap DHCP