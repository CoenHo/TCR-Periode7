function new-TcrUnattend
{
    param(
        # Parameter help description
        [Parameter(Mandatory=$true, 
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true, 
        Position = 0)]

        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]
        $ComputerName,

        # set new machine to this timezone (default W. Europe Standard Time)
        [string]
        $TimeZone = 'W. Europe Standard Time',

        # Path waar file opgeslagen moet worden
        [Parameter(Mandatory=$true, 
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true, 
        Position = 1)]

        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path,

        [Parameter(Mandatory=$true)]
        [ValidateSet("Client", "Server")]
        [string]$Version
    )
    Begin
    {
    if($Version -eq "Client") {
        $unattendTemplate = [xml]@"
<?xml version="1.0" encoding="utf-8"?>
    <unattend xmlns="urn:schemas-microsoft-com:unattend">
        <settings pass="specialize">
            <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                <TimeZone>$TimeZone</TimeZone>
                <ComputerName>$ComputerName</ComputerName>
                <RegisteredOrganization>Techniek College Rotterdam</RegisteredOrganization>
                <ProductKey>XGVPP-NMH47-7TTHJ-W3FW7-8HV2C</ProductKey>
            </component>
            <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                <InputLocale>0413:00020409</InputLocale>
                <UserLocale>nl-NL</UserLocale>
                <SystemLocale>nl-NL</SystemLocale>
                <UILanguage>en-US</UILanguage>
                <UILanguageFallback><en-U></en-U></UILanguageFallback>
            </component>
        </settings>
        <settings pass="oobeSystem">
            <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                <OOBE>
                    <HideEULAPage>true</HideEULAPage>
                    <HideLocalAccountScreen>true</HideLocalAccountScreen>
                    <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
                    <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
                    <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                    <ProtectYourPC>1</ProtectYourPC>
                </OOBE>
                <UserAccounts>
                    <LocalAccounts>
                        <LocalAccount wcm:action="add">
                            <Password>
                                <Value>UABAAHMAcwB3ADAAcgBkAFAAYQBzAHMAdwBvAHIAZAA=</Value>
                                <PlainText>false</PlainText>
                            </Password>
                            <DisplayName>Admin</DisplayName>
                            <Group>Administrators</Group>
                            <Name>Admin</Name>
                            <Description>Local Admin</Description>
                        </LocalAccount>
                    </LocalAccounts>
                </UserAccounts>
                <RegisteredOrganization>Techniek College Rotterdam</RegisteredOrganization>
                <TimeZone>$TimeZone</TimeZone>
            </component>
            <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>0413:00020409</InputLocale>
            <SystemLocale>nl-NL</SystemLocale>
            <UILanguage>en-US</UILanguage>
            <UserLocale>nl-NL</UserLocale>
            <UILanguageFallback>en-US</UILanguageFallback>
        </component>
        </settings>
        <settings pass="windowsPE">
            <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                <RunSynchronous>
                    <RunSynchronousCommand wcm:action="add">
                        <Path>reg add HKLM\System\Setup\LabConfig /v BypassTPMCheck /t reg_dword /d 0x00000001 /f</Path>
                        <Order>1</Order>
                    </RunSynchronousCommand>
                    <RunSynchronousCommand wcm:action="add">
                        <Path>reg add HKLM\System\Setup\LabConfig /v BypassRAMCheck /t reg_dword /d 0x00000001 /f</Path>
                        <Order>3</Order>
                    </RunSynchronousCommand>
                    <RunSynchronousCommand wcm:action="add">
                        <Order>2</Order>
                        <Path>reg add HKLM\System\Setup\LabConfig /v BypassSecureBootCheck /t reg_dword /d 0x00000001 /f</Path>
                    </RunSynchronousCommand>
                    <RunSynchronousCommand wcm:action="add">
                        <Path>reg add HKLM\System\Setup\LabConfig /v BypassStorageCheck /t reg_dword /d 0x00000001 /f</Path>
                        <Order>4</Order>
                    </RunSynchronousCommand>
                    <RunSynchronousCommand wcm:action="add">
                        <Path>reg add HKLM\System\Setup\LabConfig /v BypassCPUCheck /t reg_dword /d 0x00000001 /f</Path>
                        <Order>5</Order>
                    </RunSynchronousCommand>
                </RunSynchronous>
            </component>
        </settings>
    </unattend>
"@
    }
    else
    {
      
$unattendTemplate = [xml]@"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <TimeZone>$TimeZone</TimeZone>
            <RegisteredOrganization>Techniek College Rotterdam</RegisteredOrganization>
            <ComputerName>$ComputerName</ComputerName>
            <ProductKey>VDYBN-27WPP-V4HQT-9VMD4-VMK7H</ProductKey>
        </component>
        <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>0413:00020409</InputLocale>
            <SystemLocale>nl-NL</SystemLocale>
            <UILanguage>en-US</UILanguage>
            <UILanguageFallback>en-US</UILanguageFallback>
            <UserLocale>nl-NL</UserLocale>
        </component>
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <ProtectYourPC>1</ProtectYourPC>
            </OOBE>
            <UserAccounts>
                <AdministratorPassword>
                    <Value>UABAAHMAcwB3ADAAcgBkAEEAZABtAGkAbgBpAHMAdAByAGEAdABvAHIAUABhAHMAcwB3AG8AcgBkAA==</Value>
                    <PlainText>false</PlainText>
                </AdministratorPassword>
            </UserAccounts>
            <TimeZone>$TimeZOne</TimeZone>
            <RegisteredOrganization>Techniek College Rotterdam</RegisteredOrganization>
        </component>
        <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>0413:00020409</InputLocale>
            <SystemLocale>nl-NL</SystemLocale>
            <UILanguage>en-US</UILanguage>
            <UILanguageFallback>en-US</UILanguageFallback>
            <UserLocale>nl=NL</UserLocale>
        </component>
    </settings>
    <cpi:offlineImage cpi:source="wim:z:/uitgepakteiso/windowsserver2022/sources/install.wim#Windows Server 2022 SERVERSTANDARD" xmlns:cpi="urn:schemas-microsoft-com:cpi" />
</unattend>
"@
    }
    }

    Process
    {
        try
        {
            $unattend = $unattendTemplate.Clone()
            (Get-UnattendChunk -pass 'oobeSystem' -component 'Microsoft-Windows-Shell-Setup' -arch 'amd64' -unattend $unattend).TimeZone = $Timezone
            (Get-UnattendChunk -pass 'specialize' -component 'Microsoft-Windows-Shell-Setup' -arch 'amd64' -unattend $unattend).TimeZone = $Timezone
            (Get-UnattendChunk -pass 'specialize' -component 'Microsoft-Windows-Shell-Setup' -arch 'amd64' -unattend $unattend).ComputerName = [string]$ComputerName
            
                        
        }
        catch 
        {
            throw $_.Exception.Message
        }
    }

    End
    {
        $unattend.Save("$path\unattend.xml")
    }
}
function Get-UnattendChunk 
{
param
(
    [string] $pass, 
    [string] $component,
    [string] $arch, 
    [xml] $unattend
) 

# Helper function that returns one component chunk from the Unattend XML data structure
return $unattend.unattend.settings |
Where-Object -Property pass -EQ -Value $pass |
Select-Object -ExpandProperty component |
Where-Object -Property name -EQ -Value $component |
Where-Object -Property processorArchitecture -EQ -Value $arch
}