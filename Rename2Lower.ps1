#get contents of a directory and rename them to all lower case
Get-ChildItem -path c:\yourfolder | Rename-Item -NewName {$_.Name.Tolower()}
