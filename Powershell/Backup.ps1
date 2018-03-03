<#  
.SYNOPSIS  
    Backup windows machines
.DESCRIPTION  
    
.LINK  
#>

Param(
  [Parameter(Mandatory=$True)][string]$SourceDir,
  [Parameter(Mandatory=$True)][string]$DestDir,
  [Parameter(Mandatory=$True)][string]$EmailPassword,
  [Parameter(Mandatory=$True)][string]$ErrorEmailFrom,
  [Parameter(Mandatory=$True)][string]$ErrorEmailTo,
  [Parameter(Mandatory=$True)][string]$DestCompName
)

try {
    # Create Destination Directory
    $DestDir = "$($DestDir)\$($DestCompName)"
    If(!(test-path $DestDir)) {New-Item -ItemType Directory -Force -Path $DestDir}

    robocopy "$($SourceDir)" "$($DestDir)" /MIR /r:2 /w:2 /XA:SH /xd "*program Files*" "*program Files (x86)*" "*windows*" "*PerfLogs*" "*MSOCache*" "*NVIDIA*" "*$Recycle.bin*"

} catch {
    $ErrorText= ($error[0] | out-string)
    $SmtpServer = 'smtp.live.com'    
    $MailSubject = "Error Running Backup from $($SourceDir)" 
    $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $SmtpUser, $($EmailPassword | ConvertTo-SecureString -AsPlainText -Force) 
    Send-MailMessage -To "$($ErrorEmailTo)" -from "$($ErrorEmailFrom)" -Subject $MailSubject -SmtpServer $SmtpServer -UseSsl -Credential $Credentials -Body $ErrorText
}

