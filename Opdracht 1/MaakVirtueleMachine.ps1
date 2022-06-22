function New-TcrVm
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Path waar de vm opgeslagen moet worden standaard worden de instellingen van hyper-v gebruikt
        # (get-vmhost).VirtualMachinePath
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Path,

        # Generation standard is 2!
        [int]
        $Generation = 2,

        # Difference true or false
        [bool]
        $Difference,

        [string]
        $Iso,

        $NewVHDSizeBytes
    )

    Begin
    {
        if ($null -eq $path){
            $path = (get-vmhost).VirtualMachinePath
        }
    }
    Process
    {
        new-vm -name Windows11 -path $path -Generation $Generation -newVHDPath "d:\VM\Windows11\Virtual Hard Disks\Windows11-os.vhdx" -NewVHDSizeBytes 40gb
    }
    End
    {
    }
}