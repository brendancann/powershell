<#
Archives the webspy logs older than a specified date to \\DSSUAGE1\RESOURCE\PROXYLOGS
and moves the original item to e:\ironportlogs\archived
Author: BCann
Based on Wyn's original script to archive files 2 days old
To change the date adjust the number in line 12
#>

$date = Get-Date

#To adjust the date of files to be archved change the number below
$archivedate = get-Date((Get-Date).AddDays(-2))

#To change the source directory change the path below
$path = "e:\ironportlogs\"

#To change the destination of the archives change the path below and another line
$ArchivePath = "\\dssuvic01\ProxyLogs\WEBGATE"

#This gets the files (it excludes sub folders) of the directory and filters them based on the date
$files = get-childitem -path $path | where { $_.CreationTime.Date -lt $archivedate -AND ! $_.psiscontainer }

#this counts how many files are in the folder
$count = get-childitem -path $path | where { $_.CreationTime.Date -lt $archivedate -AND ! $_.psiscontainer } | measure-object 



#If 1 or more files are present and meet the date criteria they are archived. 
#If no files are present or meet the criteria the script finishes
#The destination path also needs to be changed below
if (($count).count -ge 1) 
{
foreach ($file in $files)
	{
	$filename = ($file).name
	$fullpath = "$path\$file"
	$zippedfile = "$ArchivePath\$filename"
	$zip = 'C:\Fairfax\Scripts\WebSpyLog\rar.exe'
	write-host $filename
	& "c:\windows\system32\cmd.exe" "/c start /wait " " $zip"  " a \\dssuvic01\proxylogs\webgate\$filename.rar  -ri15 -mt2 -v51200k -m5 -r- -ep1 $fullpath"
	move-item -path e:\ironportlogs\$filename -destination e:\ironportlogs\archived
	}
}
else{write-host "All logs have been archived"}

$log = 'C:\Scripts\WebSpyLog\WebSpylog.log'
add-content -value "Archive last run on $date and archived $count logs from $deletedate" -path $log
