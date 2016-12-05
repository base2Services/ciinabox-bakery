$ErrorActionPreference = "Stop"

Write-Output "Start at: $(Get-Date)"

try
{
  Get-ChildItem Env:
  Write-Output "add dirs"
  $start_time = Get-Date
  Write-Output "mkdirs"
  $dirs = @('c:\tmp', 'c:\chef', 'c:\base2')
  foreach ($dir in $dirs) {
    New-Item -ItemType directory -Path $dir -force
  }
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
