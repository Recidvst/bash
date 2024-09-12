$audioDevice = Get-AudioDevice -List | Where-Object Name -like "*EA223WM*"
$audioDevice | Set-AudioDevice -DefaultOnly
Set-AudioDevice -PlaybackVolume 55
Set-AudioDevice -PlaybackVolume 50

Start-Process "C:\Users\CS67643\AppData\Roaming\Spotify\Spotify.exe"