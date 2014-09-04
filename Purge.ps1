<#
SYNOPSIS
Deletes the w3svc logs older than a specified date in C:\inetpub\logs\LogFiles\W3SVC1

Author: BCann

To change the date adjust the number in line 12
#>


$date = Get-Date


#To adjust the date of files to be purged change the number below
$deletedate = get-Date((Get-Date).AddDays(-30))

#To change the source directory change the path below
$path = "C:\inetpub\logs\LogFiles\W3SVC1"

#This gets the files (it excludes sub folders) of the directory and filters them based on the date
$files = get-childitem -path $path | where { $_.CreationTime.Date -lt $deletedate -AND ! $_.psiscontainer }
#this counts how many files are in the folder
$count = get-childitem -path $path | where { $_.CreationTime.Date -lt $deletedate -AND ! $_.psiscontainer } | measure-object 



#If 1 or more files are present and meet the date criteria they are archived. 
#If no files are present or meet the criteria the script finishes
#The destination path also needs to be changed below
if (($count).count -ge 1) 
{
foreach ($_ in $files)
	{
	$i = $i+1
	write-host $_.fullname
	remove-item $_.fullname
	write-progress -activity "Deleting Log files" -status "Progress:" -percentcomplete ($i/$count.count*100)
	}
}
else{write-host "All logs older than $deletedate have been purged"}

$log = 'C:\Scripts\Purge\deletelogs.log'
add-content -value "Purge last run on $date and deleted $count logs from $deletedate" -path $log -encoding UTF8

