$DomainName = "corp.awesome.com"
$VMName = "dc"
$User = "CORP\awesomeadmin"
$PWord = ConvertTo-SecureString -String "p@55w0rd" -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

$ProgressPreference = "SilentlyContinue"
$WarningPreference = "SilentlyContinue"
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask -Verbose
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideClock" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "DisableNotificationCenter" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAVolume" -Value 1

Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
import-module ActiveDirectory

$username = "awesomeadmin"
do
{
    Add-Computer -DomainName $DomainName -Credential $credential -Restart -Force 
    Start-Sleep -Seconds 10
} while ($username -eq "" -or (Get-ADUser -Filter {Name -eq $username}) -eq $null)
