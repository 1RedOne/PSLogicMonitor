<#
.Synopsis
   Use this cmdlet to add a new host to logic monitor  

   You must specify -Credential and -Company for a valid logicMonitor account.
.DESCRIPTION
Long description
.EXAMPLE
   New-LMHost -credential (Get-Credential)

#>
 Function New-LMHost {
[CmdletBinding()]
param([Parameter(Mandatory=$true,Position=0)]$credential,
	[Parameter(Mandatory=$true,Position=1)]$Company,
	[Parameter(Mandatory=$true,Position=2)]$DisplayName,
	[Parameter(Mandatory=$true,Position=3)]$HostName,
	[Parameter(Mandatory=$false,Position=4)]$CollectorID=0,
	[Parameter(Mandatory=$false,Position=5)]$EnableAlerts=$false,
	[Parameter(Mandatory=$false,Position=6)]$Link,
	[Parameter(Mandatory=$false,Position=6)]$Description="Added via Powershell",
	[Parameter(Mandatory=$false,Position=7)]$Groups=35,
	[Parameter(Mandatory=$false,Position=8)][switch]$WhatIf
	)
	
	
	$auth = "&c=$Company&u=$($credential.UserName)&p=$($credential.GetNetworkCredential().Password)"
   
	
	if ($WhatIf) {
		$auth = "&c=$Company&u=$($credential.UserName)&p=HIDDEN"
	}
	$url = "https://$Company.logicmonitor.com/santaba/rpc/addHost?hostName=$HostName&displayedAs='$DisplayName'&agentId=$CollectorID"
	$url = $url + "&alertEnable=" + $EnableAlerts.toString().ToLower()
	$url = $url + "&hostGroupIds=" + $Groups
   
	if ($Link){
		$url = $url + "&link='" + $Link + "'"
	}
	if ($Description){
		$url = $url + "&description='" + $Description + "'"
	}
	
	$url = $url + $auth
	
	if ($WhatIf) {
		write-host "Running: $url"
		return
	}
	
	
	#write-host $url
	
	$resultsJSON = invoke-webrequest $url  | select -ExpandProperty Content| ConvertFrom-Json 
	if ($resultsJSON.status -ne 200) {
		Write-Error $($resultsJSON.errmsg)
		return
	} else {
		$results = $resultsJSON |  select -ExpandProperty Data 
		return $results
	}
}







#wget "https://$Company.logicmonitor.com/santaba/rpc/addHost?hostName='$HostName'&displayedAs='$DisplayName'&agentId=$AgentID&" 
