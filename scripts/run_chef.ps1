$ErrorActionPreference = "Stop"

Write-Output "Start at: $(Get-Date)"

try
{
  Write-Output "run chef"
  $start_time = Get-Date

  #$p = Start-Process -FilePath "C:\opscode\chefdk\bin\chef-client" -ArgumentList '-z -o "bake::app" *> c:\chefout.txt'-Passthru -Wait -WorkingDirectory 'c:\chef'
  #$p.WaitForExit()
  #if ($p.ExitCode -ne 0) {
  #  throw "chef run was not successful. Received exit code $($p.ExitCode)"
  #  exit 1
  #}

  cd c:\chef
  $chef_run_list = $ENV:CHEF_RUN_LIST
  cmd /c "C:\opscode\chefdk\bin\chef-client -z -o '$($chef_run_list)' -l error -L c:/chef/chefout.log"

  if ($LASTEXITCODE -ne 0) {
    throw "Chef run was not successful. Received exit code $($LASTEXITCODE)"
  }

  Write-Output "Time taken: $((Get-Date).Subtract($start_time))"
}
catch
{
  Write-Output "Caught an exception:"
  Write-Output "Exception Type: $($_.Exception.GetType().FullName)"
  Write-Output "Exception Message: $($_.Exception.Message)"
  try
  {
    $instance_id = (Invoke-WebRequest -Uri http://169.254.169.254/latest/meta-data/instance-id).Content
    $month = Get-Date -UFormat %Y-%m

    Write-S3Object -BucketName $ENV:S3_BUCKET -Key "chef/failed-runs/$($month)/$($instance_id)-chef-stacktrace.out" -File C:/Users/Administrator/.chef/local-mode-cache/cache/chef-stacktrace.out -Region $ENV:REGION
    Write-S3Object -BucketName $ENV:S3_BUCKET -Key "chef/failed-runs/$($month)/$($instance_id)-chefout.log" -File C:/chef/chefout.log -Region $ENV:REGION
  }
  catch
  {
    Write-Output "capturing debug to s3 failed"
    Write-Output "Caught an exception:"
    Write-Output "Exception Type: $($_.Exception.GetType().FullName)"
    Write-Output "Exception Message: $($_.Exception.Message)"
    exit 2
  }
  exit 1
}

exit 0
