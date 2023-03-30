<#
This script restarts the windows audio service and then 
sets the default communications device to the correct 
LG monitor so I can use my soundbar.

Context:  Audio outputs disappear often when the system resumes from sleep.  Rather than clicking through and doing 
it manually, I finally wrote a script.  Run it as administrator.

#>




write-host "Audio Fixer started!"

write-host "Restarting Windows Audio service..."
try{
    Restart-Service Audiosrv -ErrorAction Stop
}catch{
    write-host "UH OH!  Something went wrong while restarting the audio service!  The error was:"
    $error
    write-host "Press any key to exit..." -NoNewline
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    break
}
try{
    write-host "Getting audio devices..."
    $lg = Get-AudioDevice -List | Where-Object {$_.name -like "*LG ULTRAGEAR*"} -ErrorAction Stop
}catch{
        
    write-host "UH OH!  Something went wrong while retrieving audio devices!  The error was:"
    $error
    write-host "Press any key to exit..." -NoNewline
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    break

}
try{
    write-host "Attempting to set the LG monitor as the default audio device..."
    Set-AudioDevice -ID $lg.ID -ErrorAction Stop | Out-Null

    # Sometimes it runs too fast
    Start-Sleep -Milliseconds 5
}catch{
    write-host "UH OH!  Something went wrong while configuring audio devices!  The error was:"
    $error
    write-host "Press any key to exit..." -NoNewline
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    break
}

write-host "Success!  Press any key to exit..." -NoNewline
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

