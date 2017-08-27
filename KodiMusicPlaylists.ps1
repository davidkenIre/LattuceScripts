<#  
.SYNOPSIS  
    Generate Kody playlists  
.DESCRIPTION  
    This script generates Kodi playlists and writes them 
	directly to the playlist folder in Kodi
.LINK  
#>

Param(
  [Parameter(Mandatory=$True)][string]$Cred
)

Add-Type –Path 'C:\Program Files (x86)\MySQL\MySQL Connector Net 6.9.8\Assemblies\v4.5\MySql.Data.dll'
$Year=get-date -Format yyyy
$Connection = [MySql.Data.MySqlClient.MySqlConnection]@{ConnectionString=''}
$Connection.ConnectionString="server=lattuce-dc.lattuce.com;uid=xbmc;pwd=$Cred;database=mymusic56"
$OutputFile1 = "\\10.10.1.24\Userdata\playlists\music\Music Added in $($Year).m3u"
$OutputFile2 = "\\media-gym.lattuce.com\c$\Users\media\AppData\Roaming\Kodi\userdata\playlists\music\Music Added in $($Year).m3u"

$Connection.Open()
$MYSQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$MYSQLDataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter
$MYSQLDataSet = New-Object System.Data.DataSet
$MYSQLCommand.Connection=$Connection
$Sql = 'SELECT "#EXTM3U"
		UNION ALL
		SELECT CONCAT ("#EXTINF:", iDuration, ", ", strArtists, " - ", strTitle, char(13), char(10), p.strPath, s.strFileName )   
		FROM mymusic60.song s, mymusic60.path p
		where s.dateAdded is not null
		and s.dateAdded >= STR_TO_DATE(''01,01,' + $($Year) + ''',''%d,%m,%Y'')
		and s.idPath = p.idPath;'

$MYSQLCommand.CommandText = $Sql
$MYSQLDataAdapter.SelectCommand=$MYSQLCommand
$NumberOfDataSets=$MYSQLDataAdapter.Fill($MYSQLDataSet, "data")

# Remove the Existing File if it exists
If (Test-Path $OutputFile1){
	Remove-Item $OutputFile1
}
If (Test-Path $OutputFile2){
	Remove-Item $OutputFile2
}


# Write the New Playlist
foreach($DataSet in $MYSQLDataSet.tables[0]) {
	$DataSet[0] | Out-File $OutputFile1 -append -encoding ASCII
	$DataSet[0] | Out-File $OutputFile2 -append -encoding ASCII
}

$Connection.Close()