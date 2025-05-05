param (
    [string]$TargetHost = "18.228.74.153",
    [int]$Port = 3389
)

Write-Host "`n[*] Verificando RDP en $TargetHost:$Port..."

$tcpClient = New-Object System.Net.Sockets.TcpClient
$asyncResult = $tcpClient.BeginConnect($TargetHost, $Port, $null, $null)
$wait = $asyncResult.AsyncWaitHandle.WaitOne(3000, $false)

if ($wait -and $tcpClient.Connected) {
    Write-Host "[+] RDP activo en $TargetHost"
    $tcpClient.EndConnect($asyncResult)
    $tcpClient.Close()
} else {
    Write-Host "[-] RDP no disponible "
    exit 1
}

$username = "lflores1"
$password = ConvertTo-SecureString "3UZdmydkiuBZWOzK" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $password)

try {
    Invoke-Command -ComputerName $TargetHost -Credential $cred -ScriptBlock { whoami } -ErrorAction Stop | Out-Null
    Write-Host "[+] Acceso remoto OK"
} catch {
    Write-Host "[-] Fallo autenticación RDP"
}
