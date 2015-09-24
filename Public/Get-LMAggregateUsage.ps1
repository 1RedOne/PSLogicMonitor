    <#
.Synopsis
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Get-LMAggregateUsage -credential $credential  | select -First 2 | ft

    Name                       Current     Min     Max   Avg StartingUsage Change(%)
    ----                       -------     ---     ---   --- ------------- ---------
    n01_aggr_data_sas_900gb_01 42.6978 42.6244 42.8638 42.75       42.6232 1.0018 % 
    n01_aggr_root_sas_900gb_01 33.3809 33.3809 33.3823 33.38       33.3809 0 %      
.EXAMPLE
    Another example of how to use this cmdlet
#>
Function Get-LMAggregateUsage {
[CmdletBinding()]
param([Parameter(Mandatory=$true,Position=0)]$credential,$hostname='ldc-cdot1',
       [switch]$average,
       [switch]$minimum,
       [switch]$maximum)

    Write-Verbose "Statistics for $hostname"

    $auth    = "c=ivision&u=$($credential.UserName)&p=$($credential.GetNetworkCredential().Password)"


    $base = "https://ivision.logicmonitor.com/santaba/rpc/getData?$auth"

    $1st = "$base&host=$hostname&dataSource=NetApp%20cDOT%20Aggregate%20Usage-&dataPoint0=SpacePercentUsed&period=24hours"

    $min = "$1st&aggregate=min"
    $avg = "$1st&aggregate=average"
    $max = "$1st&aggregate=max"
    
    $global:hostname = $hostname
    #Pull initial results, used to grab device names
    $result = Invoke-WebRequest -Uri "$base&host=$hostname&dataSource=NetApp%20cDOT%20Aggregate%20Usage-&dataPoint0=SpacePercentUsed&period=24hours" | select -ExpandProperty Content | ConvertFrom-Json |  select -ExpandProperty Data | Select-Object -ExpandProperty Values

    #Determine names from result above
    $devices = $result | Get-Member -MemberType NoteProperty |  select Name

    #Break into each device, determine relevant stats, append properties
    Write-Debug "line 44: What the hey" 
    #Get current specs
     ForEach ($device in $devices){
        
        #Figure out better logic
        $value = if (($result.$($device.Name)[-1][2] -eq 'NaN')){
            if (($result.$($device.Name)[-2][2] -eq 'NaN')){
                $result.$($device.Name)[-3][2]
            }
             else{$result.$($device.Name)[-2][2]}
            }
            else{
            $result.$($device.Name)[-1][2]
        }


        $ThisDeviceCurrent= [math]::Round($value,4)
        Write-Debug "test current value, currently $([math]::Round($value,4))"
        Write-Debug '[math]::Round(($result.$($device.Name)[-2][2]),4)'
        $devices | Where Name -eq $device.Name | Add-Member -MemberType NoteProperty -Name Current -Value $ThisDeviceCurrent
        }

     #get min
     $result = Invoke-WebRequest -Uri $min | select -ExpandProperty Content | ConvertFrom-Json |  select -ExpandProperty Data | Select-Object -ExpandProperty Values
     ForEach ($device in $devices){
        
        $ThisDeviceMin= [math]::Round($($($result.$($device.Name))[2]),4)
        $devices | Where Name -eq $device.Name | Add-Member -MemberType NoteProperty -Name Min -Value $ThisDeviceMin
        }

     #get max
     $result = Invoke-WebRequest -Uri $max | select -ExpandProperty Content | ConvertFrom-Json |  select -ExpandProperty Data | Select-Object -ExpandProperty Values
     ForEach ($device in $devices){
        
        $ThisDeviceMax = [math]::Round($($($result.$($device.Name))[2]),4)
        $devices | Where Name -eq $device.Name | Add-Member -MemberType NoteProperty -Name Max -Value $ThisDeviceMax
        }
     #get avg
     $result = Invoke-WebRequest -Uri $avg | select -ExpandProperty Content | ConvertFrom-Json |  select -ExpandProperty Data | Select-Object -ExpandProperty Values
     ForEach ($device in $devices){
        
        $ThisDeviceAvg= [math]::Round($($($result.$($device.Name))[2]),2)
        $devices | Where Name -eq $device.Name | Add-Member -MemberType NoteProperty -Name Avg -Value $ThisDeviceAvg
        }
     #get starting values
     $start = Invoke-WebRequest $1st | select -ExpandProperty Content | ConvertFrom-Json |  select -ExpandProperty Data | Select-Object -ExpandProperty Values
      ForEach ($device in $devices){
            $ThisDeviceStart = [math]::Round($($($start.$($device.Name))[0])[-1], 4)
            $devices | Where Name -eq $device.Name | Add-Member -MemberType NoteProperty -Name StartingUsage -Value $ThisDeviceStart
        }

     #get change
     ForEach ($device in $devices){
            $change = if ($device.Current -eq $device.StartingUsage) {"0 %"}else {"$([math]::Round((($device.Current / $device.StartingUsage )),4)) %"}
        
            $devices | Where Name -eq $device.Name | Add-Member -MemberType NoteProperty -Name 'Change(%)' -Value $change
        }

        #cleanup the Name
    ForEach ($device in $devices){
    $device.Name = $device.Name -replace 'NetApp cDOT Aggregate Usage-',''
     }


    return $devices
 }
 
