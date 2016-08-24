$ErrorActionPreference = "Stop"

Write-Output "Start at: $(Get-Date)"

try
{
  Write-Output "Downloading chef_dk"
  $omniUrl = "https://omnitruck.chef.io/install.ps1"
  $installScript = Invoke-WebRequest -UseBasicParsing $omniUrl
  $installScript | Invoke-Expression
  $start_time = Get-Date
  install -channel stable -project chefdk
  Write-Output "Time taken: $((Get-Date).Subtract($start_time))"

  #  $url = "https://packages.chef.io/stable/windows/2008r2/chef-client-12.9.41-1-x64.msi"
  #$download_destination = "c:\base2\chef.msi"
  #$start_time = Get-Date
  #$wc = New-Object System.Net.WebClient
  #$wc.DownloadFile($url, $download_destination)
}
catch
{
  Write-Output "Caught an exception:"
  Write-Output "Exception Type: $($_.Exception.GetType().FullName)"
  Write-Output "Exception Message: $($_.Exception.Message)"
  exit 1
}

exit 0
