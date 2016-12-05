$EC2SettingsFile="C:\Program Files\Amazon\Ec2ConfigService\Settings\config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2SetPassword")
    {
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2HandleUserData")
    {
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2DynamicBootVolumeSize")
    {
        $element.State="Enabled"
    }
}
$xml.Save($EC2SettingsFile)
