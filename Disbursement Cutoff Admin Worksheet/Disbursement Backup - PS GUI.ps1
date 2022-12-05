## Disbursement Backup - PS GUI

## install module (one-time)
# Install-Module dbatools 
## Source: https://dbatools.io/download/

# Import Module
#Import-Module dbatools

## Variables
$db = Start-Job -ScriptBlock {Import-Module dbatools}
$server = '13DEV2'
$databases = @('13Software','13Software_audit')
$results = @()
$logDate = Get-Date -Format 'yyyyMMdd'
$logTime = Get-Date -Format 'HHmmss'
$logCleanup = (Get-Date).AddMonths(-3)
$logPath = "$PSScriptRoot\log\$scriptName" 
$logFile = $server + '_Disbursement_Backup_' + $logDate + '_' + $logTime + '.txt'


#Setup Form
Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Disbursement Backup Program'
$main_form.Width = 300
$main_form.Height = 300
$main_form.AutoSize = $true

######## Add content to form

## Last Backup Label
$LastBackup_Label = New-Object System.Windows.Forms.Label
$LastBackup_Label.Text =  "Get Backup History"
$LastBackup_Label.Location = New-Object System.Drawing.Point(10, 20)
$main_form.Controls.Add($LastBackup_Label)

## Last Backup Label
$Error_Label = New-Object System.Windows.Forms.Label
$Error_Label.Text =  ""
$Error_Label.Location = New-Object System.Drawing.Point(10, 120)
$main_form.Controls.Add($Error_Label)

## Last Backup Text Label
$LastBackupTest_LabelTitle = New-Object System.Windows.Forms.Label
$LastBackupTest_LabelTitle.Text =  "Last Backup:"
$LastBackupTest_LabelTitle.Location = New-Object System.Drawing.Point(10, 50)
$main_form.Controls.Add($LastBackupTest_LabelTitle)

## Last Backup Text Label
$LastBackupTest_Label = New-Object System.Windows.Forms.Label
$LastBackupTest_Label.Text =  "Unknown"
$LastBackupTest_Label.Location = New-Object System.Drawing.Point(120, 50)
$main_form.Controls.Add($LastBackupTest_Label)

#Get-DbaDbBackupHistory -SqlInstance $server -Database $databases[0], $databases[1] -Last -DeviceType Disk | Select-Object Database, End, Path
# Last Backup Button
$LastBackupButton = New-Object System.Windows.Forms.Button
$LastBackupButton.Size = New-Object System.Drawing.Size(120,23)
$LastBackupButton.Location = New-Object System.Drawing.Size(200,20)
$LastBackupButton.Text = "Get Last Backup"
$LastBackupButton.BackColor = 'LIGHTBLUE'
$main_form.Controls.Add($LastBackupButton)


## Disbursement Backup Label
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Run Disbursement Backup"
$Label.Location  = New-Object System.Drawing.Point(10,80)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)

## Start Button
$StartButton = New-Object System.Windows.Forms.Button
$StartButton.Size = New-Object System.Drawing.Size(120,23)
$StartButton.Location = New-Object System.Drawing.Size(200,80)
$StartButton.Text = "START"
$StartButton.BackColor = 'GREEN'
$main_form.Controls.Add($StartButton)

## StartButton Click Action Event - START BACKUP
$StartButton.Add_Click( { 
try {
    ## Added 8/4 to show context that it's running
    $StartButton.BackColor = 'YELLOW' 
    $StartButton.Text = "Running..." 
    [System.Windows.Forms.Application]::DoEvents()
    startBackup
}
catch {
    $Error_Label.Text = "error"
    [System.Windows.Forms.Application]::DoEvents()
}
finally {
    ## added 8/4 to show it's done
    ## run getLastBackup to update label
    getLastBackup

    ## set start button back to default 
$StartButton.Text = "START"
$StartButton.BackColor = 'GREEN'
    [System.Windows.Forms.Application]::DoEvents()

}
 } )

 ## LastBackupButton Click Action Event - VIEW LAST BACKUP
$LastBackupButton.Add_Click( { 
try {

    ## Added 8/4 to show context that it's running
    $LastBackupButton.BackColor = 'YELLOW' 
    $LastBackupButton.Text = "Processing..." 
    [System.Windows.Forms.Application]::DoEvents()
    getLastBackup
    #Get-DbaDbBackupHistory -SqlInstance $server -Database $databases[0], $databases[1] -Last -DeviceType Disk | Out-GridView -Title "Backup History" -PassThru | Select-Object Database, End, Path

    }
    catch
    {
    $Error_Label.Text = "error"
    [System.Windows.Forms.Application]::DoEvents()

    }
    finally {
    $LastBackupButton.Text = "View Last Backup"
    $LastBackupButton.BackColor = 'LIGHTBLUE' 
    [System.Windows.Forms.Application]::DoEvents()  
    }
} )

function getLastBackup {

 $LastBackupTest_Label.text = Get-DbaDbBackupHistory -SqlInstance $server -Database $databases[0] -Last -DeviceType Disk | foreach {$_.End}
    [System.Windows.Forms.Application]::DoEvents()

}

function startBackup {
#$connection = New-Object System.Data.SqlClient.SqlConnection("Data Source=13DEV2;Initial Catalog=msdb;Integrated Security=SSPI")
# $command =  New-Object System.Data.SqlClient.SqlCommand("dbo.sp_start_job", $connection)
# $command.CommandType = [System.Data.CommandType]::StoredProcedure
# ($command.Parameters.Add("@job_name", [System.Data.SqlDbType]::NVarChar, 128)).Value = "Disbursement Backup.Subplan_1"
# $connection.Open()
# $command.ExecuteNonQuery()
# $connection.Close()

ForEach($db in $databases){
                $date = Get-Date -Format 'yyyyMMdd'
                $time = Get-Date -Format 'HHmmss'
                #$path = '\\13backups21\SQL\DISBURSEMENT\' + $server + '\' + $db + '\FULL\'
                $path = 'E:\SQL\Disbursement\' + $server + '\' + $db + '\FULL\'
                $fileName = $server + '_' + $db + '_FULL_' + $date + '_' + $time + '.bak'
                try {
                    Backup-DbaDatabase -SqlInstance $server -Database $db -Path $path -FilePath $fileName -CompressBackup -IgnoreFileChecks
                    #start-sleep -Seconds 300
                    }
                catch {
                     Write-Host "Error: $($_.Exception.Message)"
                }

}
}



 ## Call at end 
 
$main_form.ShowDialog()

