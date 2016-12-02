    <#
.Synopsis
    Need to look up all of the devices in a LogicMonitor host group?  This is the cmdlet for you.
.DESCRIPTION
    Long description
.EXAMPLE
    Get-LMHostGroup -credential $credential -Company $company | ? Name -like "KSL*"  | Get-LMHostGroupChildren


alertEnable           : True
createdOn             : 1404416417
groupType             : 0
id                    : 36
parentId              : 35
numOfHosts            : 5
status                : alert-confirmed
description           : 
appliesTo             : 
name                  : Atlanta
signaled              : True
inSDT                 : False
fullPath              : KSL/Atlanta
type                  : HOSTGROUP
inNSP                 : False
effectiveAlertEnabled : True

alertEnable           : True
createdOn             : 1404416633
groupType             : 0
id                    : 37
parentId              : 35
numOfHosts            : 5
status                : alert-confirmed
description           : QTS Suwanee
appliesTo             : 
name                  : BCS
signaled              : True
inSDT                 : False
fullPath              : KSL/BCS
type                  : HOSTGROUP
inNSP                 : False
effectiveAlertEnabled : True

Get a listing of all the children device within a host group
.EXAMPLE
Get a listing of all device, grouped by the Host

Get-LMHostGroup -credential $credential -Company $company | Get-LMHostGroupChildren 
#>
 Function Get-LMHostGroupChildren {
[CmdletBinding()]
param($credential=$global:credential,
      [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]$id,
	  [Parameter(Mandatory=$true,Position=2)]$Company)

    $auth = "c=$Company&u=$($credential.UserName)&p=$($credential.GetNetworkCredential().Password)"
   
    $base = "https://$Company.logicmonitor.com/santaba/rpc/getHostGroupChildren?hostGroupId=$id&$auth"
 $results = invoke-webrequest $base  | select -ExpandProperty Content| ConvertFrom-Json |  select -ExpandProperty Data 
 write-debug "test me"
 return ($results.items )
 }

