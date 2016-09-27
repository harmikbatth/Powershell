##############################################################################
##----------------------------------------------------------------------------
## Test HTTP Redirection, Website Availability and Response Time
##----------------------------------------------------------------------------
## Author: Harmik Singh Batth
## Date: 19 Sep 2016
## Version: 1.0
## Email: harmikbatth@gmail.com
## Changes: 
##
##############################################################################

#Clear the scrren
Clear-host

#URL to be monitored

Try
{	
	$resp = $null
	## Request the URI, and measure how long the response took.
	$result = Measure-Command 	{   
		$url ="http://www.sysinternals.com/"
		write-Host "Initiating connection to $Url"
		
		$req = [System.Net.WebRequest]::Create($Url)	
		$resp = $req.GetResponse()
		If ($resp.ResponseUri.OriginalString -eq $Url) 
		{
	         Write-host "Website is not being redirected"
	    } 
		Else 
		{
			$redirected = $resp.ResponseUri.OriginalString 
			Write-host "Website is redirected from $url to $redirected" -foregroundcolor "green" 
		}
	}
	$resp 
	$TotalTimeinMS = $result.TotalMilliseconds
	$TotalTimeinSec = $result.seconds
	write-host ""
	write-host "Total Time taken to get response is $TotalTimeinMS ms or $TotalTimeinSec sec" -foregroundcolor "green" 	
}
catch
{	
	$ErrMsg = $_.Exception.Message		
	
	if ($ErrMsg -match "The remote name could not be resolved") 
	{ 
		write-host "ERROR: cannot connect to the URL" -foregroundcolor "red" 
	} 
	ElseIf ($ErrMsg -match "The operation has timed out")
	{
		write-host "ERROR: Script not able to mointor the wesbite in timely manner, please check again in a minute or so" -foregroundcolor "red" 
	}
	Else 
	{ 
		Write-host "ERROR: $ErrMsg"
	 
	} 
	write-host "" 	
	$error.clear()
}
Finally
{
	$resp.dispose()		
}	 

Write-host "Total Time taken to run script is $time " 


