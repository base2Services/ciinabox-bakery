$ErrorActionPreference = "Stop"
Set-ExecutionPolicy Bypass -force
Write-Output "Start at: $(Get-Date)"
try
{
  Write-Output "Removing Chef from the image"
  $start_time = Get-Date
  Write-Output "Uninstalling the Chef package"
  Get-Package -Name "Chef*" | Uninstall-Package -Confirm
  Write-Output "Deleting the C:/chef directory"
  Remove-Item -Recurse -Force C:/chef
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
