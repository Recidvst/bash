(Get-AudioDevice -list | Where-Object Name -like ("*jabra*") | Set-AudioDevice -DefaultOnly).Name
