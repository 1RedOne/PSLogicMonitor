#PSLogicMonitor
===========
Some PowerShell Cmdlets to work with LogicMonitor's various APIs

Installation
------------
 * Copy the "PSLogicMonitor" folder into your module path. Note: You can find an
appropriate directory by running `$ENV:PSModulePath.Split(';')`.
 * Run `Import-Module PSLogicMonitor` from your PowerShell command prompt.

Usage
-----
 
#####Get Logic Monitor NetApp Aggregate Usage Statistics
    >Get-LMAggregateUsage -credential $credential  | select -First 2 | ft
    
    Name                       Current     Min     Max   Avg StartingUsage Change(%)
    ----                       -------     ---     ---   --- ------------- ---------
    n01_aggr_data_sas_900gb_01 42.6978 42.6244 42.8638 42.75       42.6232 1.0018 % 
    n01_aggr_root_sas_900gb_01 33.3809 33.3809 33.3823 33.38       33.3809 0 % 
 
 >Defaults to displaying information for **ldc-cdot1**, but any **Hostname** can be provided via the -HostName parameter
 

#####Generate a Logic Monitor Style Report
    >$HTMLBody = New-LMReport -description "Aggregate Volumes over the last 24 hours" -company 'CompanyNameGoesHere' `
    -reportName 'NetApp Volumes over Thresholds' -inputobject (Get-LMAggregateUsage -credential $credential -Verbose -HostName $HostName) -subtitle $HostName
    
    New-SMTPMessage -Body $HtmlBody <other params go here>
 
 >Generates a LogicMonitor Style report in HTML, with a Description of $Description, a custom Report Name, and CompanyName
 
 ####### Example Report

 
![Althought this data woudl be embedded in an email, usually, this is what the report looks like](https://github.com/1RedOne/PSLogicMonitor/blob/master/img/img01.png)
 
