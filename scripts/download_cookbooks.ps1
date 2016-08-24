$ErrorActionPreference = "Stop"

Write-Output "Start at: $(Get-Date)"

try
{
  Write-Output "Downloand and unzip cookbooks"
  $start_time = Get-Date
  $BackUpPath = "C:\base2\chef.zip"
  $Destination = "C:\chef\"
  $CookbookDir = "C:\chef\cookbooks"
  Write-Output "going to download"
  Read-S3Object -Region ap-southeast-2 -BucketName $ENV:S3_BUCKET -Key /chef/latest/cookbooks.zip -File C:\base2\chef.zip
  Write-Output "delete dir"
  if(Test-Path -Path $CookbookDir ){
    Remove-Item -Recurse -Force $CookbookDir
  }
  Write-Output "unzip"
  Add-Type -assembly "system.io.compression.filesystem"
  [io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)

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
