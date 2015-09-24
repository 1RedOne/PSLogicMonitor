Function New-LMReport {
param($description,$company,$reportName,$inputobject,
 [Parameter(Mandatory=$false, 
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
         [Alias("subtitle")]$hostname)

$header = @"
<table width="55%" cellpadding="0" cellspacing="0" border="0" id="noformat">

<tr valign="top">
  <td colspan="34"><img alt="" src="&nbsp;" style="width: 1190px; height: 12px;"/></td>
</tr>
<Tr>
<td>&nbsp;</td>
<td colspan="4"><img src="file:///C:/Users/Stephen/Dropbox/Docs/iVision/Scripts/onereport.gif" style="height: 31px" alt=""/></td>
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
$code = $inputObject | ConvertTo-Html -Head $header -CssUri C:\git\PSLogicMonitor\Style.css
$code -replace '<table>','<table id="data">'
}

New-LMReport -description "Aggregate Volumes over the last 24 hours" -company 'King&Spalding' `
    -reportName 'NetApp Volumes over Thresholds' -inputobject $res -subtitle ldc-cdot01 > t:\file.html