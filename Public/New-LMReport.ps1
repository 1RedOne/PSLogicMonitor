Function New-LMReport {
param($description,$company,$reportName,
[Parameter(Mandatory=$false, 
                    ValueFromPipeline=$true,ValueFromRemainingArguments=$true)]$inputobject,
[Parameter(Mandatory=$false, 
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
         [Alias("subtitle")]$hostname=$global:hostname)

$header = @"
<style>
html {
	margin: 0;
	padding: 0;
	}
body { 
	font: 75% georgia, sans-serif;
	line-height: 1.88889;
	color: #555753; 
	background: #fff ;
	margin: 0; 
	padding: 0;
	}
p { 
	margin-top: 0; 
	text-align: justify;
	}
h3 { 
	font: italic normal 1.4em georgia, sans-serif;
	letter-spacing: 1px; 
	margin-bottom: 0; 
	color: #7D775C;
	}
a:link { 
	font-weight: bold; 
	text-decoration: none; 
	color: #B7A5DF;
	}
a:visited { 
	font-weight: bold; 
	text-decoration: none; 
	color: #D4CDDC;
	}


.intro { 
	min-width: 470px;
	width: 100%;
	}
	table#data{
		margin-left: 45px;
		margin-top: 15px;
		padding-top: 10px;
		padding-left: 15%;
	}
	table#data tr:nth-child(odd)		{ background-color:#eee; }
	table#data tr:nth-child(even)		{ background-color:#fff; }

	
header {
	padding-top: 20px;
	height: 87px;
}


footer { 
	text-align: center; 
	}
footer a:link, footer a:visited { 
	margin-right: 20px; 
	}


.extra1 {
	background: transparent url(cr2.gif) top left no-repeat; 
	position: absolute; 
	top: 40px; 
	right: 0; 
	width: 148px; 
	height: 110px;
	}
</style>
<table width="55%" cellpadding="0" cellspacing="0" border="0" id="noformat">
<tr valign="top">
  <td colspan="34"><img alt="" src="&nbsp;" style="width: 1190px; height: 12px;"/></td>
</tr>
<Tr>
<td>&nbsp;</td>
<td colspan="4"><img src="http://ivision.com/wp-content/themes/ivision-fifteen/images/logo_color.png" alt=""/></td>
  <td colspan="4">&nbsp;</td>
  <td colspan="24" valign="middle" style="text-align: right;"><h3>$Company - $reportName</h3><br><i>Data gathered from <b>$subtitle</b></i></td>
  </tr>
<tr valign="top">
  <td>&nbsp;</td>
  <td colspan="32" style="border-top-style: solid; border-top-width: 1px; border-top-color: #666666; ">&nbsp;</td>
  <td><img alt="" src="&nbsp;" style="width: 20px; height: 1px;"/></td>
</tr>
<tr valign="top">
  <td><img alt="" src="&nbsp;" style="width: 20px; height: 14px;"/></td>
  <td colspan="3"><b>Company:<b></td>
  <td colspan="20">$company</td>
  <td colspan="2"><img alt="" src="&nbsp;" style="width: 67px; height: 14px;"/></td>
  <td><b>From:</b></td>
  <td><img alt="" src="&nbsp;" style="width: 1px; height: 14px;"/></td>
  <td colspan="4" style="text-align: right;">$((Get-Date).AddDays(-1))</td>
  <td colspan="2"><img alt="" src="&nbsp;" style="width: 21px; height: 14px;"/></td>
</tr>
<tr valign="top">
  <td><img alt="" src="&nbsp;" style="width: 20px; height: 14px;"/></td>
  <td colspan="3"><b>Powered By:</b></td>
  <td colspan="20">LogicMonitor Inc.</td>
  <td colspan="2"><img alt="" src="&nbsp;" style="width: 67px; height: 14px;"/></td>
  <td><b>Thru:</b></td>
  <td><img alt="" src="&nbsp;" style="width: 1px; height: 14px;"/></td>
  <td colspan="4" style="text-align: right;">$(Get-date)</td>
  <td colspan="2"><img alt="" src="&nbsp;" style="width: 21px; height: 14px;"/></td>
</tr>
<tr valign="top">
  <td><img alt="" src="&nbsp;" style="width: 20px; height: 14px;"/></td>
  <td colspan="3"><b>Description:</b></td>
  <td colspan="20"><strong>$description</strong></td>
  <td colspan="2"><img alt="" src="&nbsp;" style="width: 67px; height: 14px;"/></td>
  <td><b>TimeZone:</b></td>
  <td><img alt="" src="&nbsp;" style="width: 1px; height: 14px;"/></td>
  <td colspan="4" style="text-align: right;">Eastern Standard Time</td>
  <td colspan="2"><img alt="" src="&nbsp;" style="width: 21px; height: 14px;"/></td>
"@
$code = $inputObject | ConvertTo-Html -Head $header
$code -replace '<table>','<table id="data">'
}

New-LMReport -description "Aggregate Volumes over the last 24 hours" -company 'King&Spalding' `
    -reportName 'NetApp Volumes over Thresholds' -inputobject (Get-LMAggregateUsage -credential $credential -Verbose) -subtitle ldc-cdot01 > t:\file.html