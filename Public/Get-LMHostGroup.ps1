 Function Get-LMHostGroup {
[CmdletBinding()]
param([Parameter(Mandatory=$true,Position=0)]$credential,
      [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]$id)

    $auth = "c=ivision&u=$($credential.UserName)&p=$($credential.GetNetworkCredential().Password)"
   if (-not($id)){$base = "https://ivision.logicmonitor.com/santaba/rpc/getHostGroups?$auth"}
             else{$base = "https://ivision.logicmonitor.com/santaba/rpc/getHostGroup?hostGroupId=$id&$auth"}
 $results = invoke-webrequest $base  | select -ExpandProperty Content| ConvertFrom-Json |  select -ExpandProperty Data 
 write-debug "test me"
 return ($results | select Name,FullPath,id | sort Fullpath)
 }

