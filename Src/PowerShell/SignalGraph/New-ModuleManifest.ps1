$root = "$PSScriptRoot"
if ($root -ne (Get-Location).Path) {
    Set-Location $root
}


New-ModuleManifest -Path ./SignalGraph.psd1 `
  -RootModule 'SignalGraph.psm1' `
  -ModuleVersion '1.0.0' `
  -Author 'Silicon Dream Artists' `
  -CompanyName 'Silicon Dream Artists' `
  -Copyright '(c) Silicon Dream Artists. Current copyright holder: BDDB LLC.' `
  -Description 'Native PowerShell implementation of the Signal protocol format, used in SovereignTrust for verifiable, structured execution results.' `
  -Tags "'Signal' 'SovereignTrust' 'Messaging' 'StructuredLog'" `
  -LicenseUri 'https://opensource.org/licenses/MIT' `
  -ProjectUri 'https://github.com/B-D-D-B/SignalGraph' `
  -CompatiblePSEditions 'Core' `
  -PowerShellVersion '5.1'

 
  # SignalGraph.psm1 embeds its classes for parse-time module export.
