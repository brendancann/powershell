$list = Get-ChildItem "C:\Example" | Where-Object { $_.CreationTime -le (Get-Date).AddMonths(-1)}

foreach ($file in $list) {
		remove-item $file
		}
