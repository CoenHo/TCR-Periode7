<#
.Synopsis
   Short description
.DESCRIPTION
   Maak een virtuele machine voor gebruik op TCR
.EXAMPLE
   Gebruik deze syntax als je differencing wil gebruiken
   new-tcrvm -Name DC1 -ParentPath "D:\VM\Base\ws2022_STD_21-03-2022-UEFI.vhdx"
.EXAMPLE
   Accepteert invoer vanaf tekst of cli
   "dc1","dc2","rtr","exch","web" | new-tcrvm -ParentPath "D:\VM\Base\ws2022_STD_21-03-2022-UEFI.vhdx"
.EXAMPLE
   Je kan ook een VM maken met een eigen VHD
   "dc1","dc2","rtr","exch","web" | new-tcrvm -Name DC1 -Iso "E:\ISO\Srv2019Eval.ISO"
.EXAMPLE
   Accepteert invoer vanaf tekst of cli
   new-tcrvm -Name DC1 -Iso "E:\ISO\Srv2019Eval.ISO"
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function New-TcrVm {
    [CmdletBinding(DefaultParameterSetName = "Differencing")]
    [Alias()]
    [OutputType([int])]
    Param
    (
        #Name is de naam van de VM die aangemaakt wordt, accepteerd pipeline en meerdere waarden
        #"coen","jan","tine","felix","hannah" | new-tcrvm
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = "NonDifferencing",
            Position = 0)]
        [Parameter(ParameterSetName = "Differencing",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]                   
        [string[]]
        $Name,
        # Path waar de vm opgeslagen moet worden standaard worden de instellingen van hyper-v gebruikt
        # (get-vmhost).VirtualMachinePath
        [Parameter(ParameterSetName = "Differencing")]
        [Parameter(ParameterSetName = "NonDifferencing")]
        $Path,

        # Generation standard is 2!
        [Parameter(ParameterSetName = "Differencing")]
        [Parameter(ParameterSetName = "NonDifferencing")]
        [int]
        $Generation = 2,

        #Pad naar ISO bestand
        [Parameter(ParameterSetName = "NonDifferencing",
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Iso,

        #Grootte van de VHD in GB
        [Parameter(ParameterSetName = "NonDifferencing")]
        $NewVHDSizeBytes,

        [Parameter(ParameterSetName = "Differencing",
            ValueFromPipelineByPropertyName = $true)]
        [string]
        $ParentPath,

        #Verbind met een VmSwitch standaard wordt met niet verbonden
        [Parameter(ParameterSetName = "Differencing")]
        [Parameter(ParameterSetName = "NonDifferencing")]
        [string]
        $SwitchName
    )

    Begin {
       
        if ($null -eq $NewVHDSizeBytes) { $NewVHDSizeBytes = 60GB } else { $NewVHDSizeBytes }
        
        if ($null -eq $path) { $path = (get-vmhost).VirtualMachinePath }
    }
    Process {
        if ( $PsCmdlet.ParameterSetName -eq "NonDifferencing") { 
            foreach ($currentItemName in $name) {
                $currentItemName = "TCR-$currentItemName"
                $vhdpath = "$path\$currentItemName\Virtual Hard Disks\$currentItemName-os.vhdx"
                
                write-verbose $currentItemName
                if ($null -eq $SwitchName)
                {
                    $vm = new-vm -name $currentItemName -path $path -Generation $Generation -newVHDPath $vhdpath  -NewVHDSizeBytes $NewVHDSizeBytes
                }
                else
                {
                    $vm = new-vm -name $currentItemName -path $path -Generation $Generation -newVHDPath $vhdpath  -NewVHDSizeBytes $NewVHDSizeBytes -SwitchName $SwitchName
                }    
                Add-VMDvdDrive -VMName $currentItemName -Path $iso | out-null
                Set-vm -VMName $currentItemName -AutomaticCheckpointsEnabled $false -ProcessorCount 4 | out-null
                Set-VMFirmware -VMName $currentItemName -FirstBootDevice (Get-VMDvdDrive -VMName $currentItemName) | out-null
                $props = @{ Name = $vm.Name
                    Path = $vm.Path
                    ProcessorCount = $vm.ProcessorCount
                    AutomaticCheckpointsEnabled = $vm.AutomaticCheckpointsEnabled}

        $object = new-object -TypeName psobject -Property $props

        write-output $object
            }
        }
        else {  
            foreach ($currentItemName in $name) {
                $currentItemName = "TCR-$currentItemName"
                $vhdpath = "$path\$currentItemName\Virtual Hard Disks\$currentItemName-os.vhdx"
                test-path -path $vhdpath -ErrorAction Stop
                write-verbose $currentItemName
                if($null -eq $SwitchName)
                {
                    $vm = new-vm $currentItemName -Generation $Generation -NoVHD -path $path
                }
                else
                {
                    $vm = new-vm $currentItemName -Generation $Generation -NoVHD -path $path -SwitchName $SwitchName
                }
                    new-vhd -Differencing -ParentPath $ParentPath -path $vhdpath | out-null
                Add-VMHardDiskDrive -VMName $currentItemName -path $vhdpath | out-null
                Set-vm -VMName $currentItemName -AutomaticCheckpointsEnabled $false -ProcessorCount 4 | out-null
                Set-VMFirmware -VMName $currentItemName -FirstBootDevice (Get-VMHardDiskDrive -VMName $currentItemName) | out-null

                $props = @{ Name = $vm.Name
                            Path = $vm.Path
                            ProcessorCount = $vm.ProcessorCount
                            AutomaticCheckpointsEnabled = $vm.AutomaticCheckpointsEnabled}

                $object = new-object -TypeName psobject -Property $props

                write-output $object
            }
        }
    }
    End {
        write-verbose "pad waar de VM opgeslagen wordt is $path"
        if ($PsCmdlet.ParameterSetName -eq "NonDifferencing") {
            write-verbose "Schijgrootte is $([math]::round($NewVHDSizeBytes /1Gb, 3)) GB"
        }
             
    }
}