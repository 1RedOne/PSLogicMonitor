<#
.Synopsis
   Use this cmdlet to see a listing of all of the visible HostGroups in Logic Monitor for a given user ID.  

   You must specify -Credential and -Company for a valid logicMonitor account.
.DESCRIPTION
Long description
.EXAMPLE
   Get-LMHostGroup -credential (Get-Credential)

name                        fullPath                                                 id
----                        --------                                                 --
ASH                         ASH                                                      46
Cloud-DEN                   ASH/Cloud-DEN                                           205
Norcross                    ASH/Norcross                                            115
Application Servers         ASH/Norcross/Application Servers                        210
Backup Servers              ASH/Norcross/Application Servers/Backup Servers         211
Domain Controllers          ASH/Norcross/Application Servers/Domain Controllers     212

   Returns a listing of all HostGroups visible, perfect for filtering with Where-Object in the pipeline.
.EXAMPLE
Get-LMHostGroup -credential $credential -Compant $company | ? Name -like "KSL*"  | Get-LMHostGroupChildren


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

   In this example, the pipeline is used to send the results of this cmdlet on to Get-LMHostGroupChildren, to enumerate all of the devices in a host group.
#>
 Function Get-LMHostGroup {
[CmdletBinding()]
param([Parameter(Mandatory=$true,Position=0)]$credential,
      [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]$id,
	  [Parameter(Mandatory=$true,Position=2)]$Company)

    $auth = "c=$Company&u=$($credential.UserName)&p=$($credential.GetNetworkCredential().Password)"
   if (-not($id)){$base = "https://$Company.logicmonitor.com/santaba/rpc/getHostGroups?$auth"}
             else{$base = "https://$Company.logicmonitor.com/santaba/rpc/getHostGroup?hostGroupId=$id&$auth"}
 $results = invoke-webrequest $base  | select -ExpandProperty Content| ConvertFrom-Json |  select -ExpandProperty Data 
 write-debug "test me"
 return ($results | select Name,FullPath,id | sort Fullpath)
 }

