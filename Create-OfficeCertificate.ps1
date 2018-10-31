[CmdletBinding()]
param(
  [Parameter(HelpMessage="Country Name (2 letter code) [NO]")]
  [String]$country = "NO",
  [Parameter(HelpMessage = "State or Province Name (full name) [Some-State]")]
  [String]$province = "Oslo",

  [Parameter(HelpMessage = "Locality Name (eg, city) []")]
  [String]$locality = "Oslo",

  [Parameter(HelpMessage = "Organization Name (eg, company) [Internet Widgits Pty Ltd]")]
  [String]$organisation = "Internet Widgits Pty Ltd",

  [Parameter(HelpMessage = "Number of years until expiration (default is 1, max is 30)")]
  [int]$expireInYears = 1
)

$ScriptPath = Split-Path $MyInvocation.InvocationName
Write-Host $ScriptPath
$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = "$ScriptPath\keycred-win.exe"
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.CreateNoWindow = $true

$pinfo.Arguments = "--newcert y --country NO --province Oslo --locality Oslo --ou IT --org Inmeta --expireinyears $expireInYears --commonname Test"

$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$stdout = $p.StandardOutput.ReadToEnd()
$stderr = $p.StandardError.ReadToEnd()

$p.WaitForExit()

if ($stderr) {
    throw $stderr
}

$stdout  | ConvertFrom-Json

