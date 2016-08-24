$ErrorActionPreference = "Stop"

Write-Output "Start at: $(Get-Date)"

try
{
  Write-Output "Downloading aws msi"
  $url = "https://s3.amazonaws.com/aws-cli/AWSCLI64.msi"
  $download_destination = "c:\base2\aws.msi"
  $start_time = Get-Date
  $wc = New-Object System.Net.WebClient
  $wc.DownloadFile($url, $download_destination)
  Write-Output "Time taken: $((Get-Date).Subtract($start_time))"


  Write-Output "Installing aws msi"
  $start_time = Get-Date
  $p = Start-Process -FilePath "msiexec" -ArgumentList "/qn /i $download_destination" -Passthru -Wait
  $p.WaitForExit()
  if ($p.ExitCode -ne 0) {
    throw "msiexec was not successful. Received exit code $($p.ExitCode)"
    exit 1
  }
  $env:Path += ";C:\Program Files\Amazon\AWSCLI\"
  Write-Output "Time taken: $((Get-Date).Subtract($start_time))"
}
catch
{
  Write-Output "Caught an exception:"
  Write-Output "Exception Type: $($_.Exception.GetType().FullName)"
  Write-Output "Exception Message: $($_.Exception.Message)"
  exit 1
}

exit 0
