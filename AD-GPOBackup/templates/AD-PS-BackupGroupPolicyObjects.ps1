function ClearOldLogs($clPath, $clTime)
{
$limit = (Get-Date).AddDays($clTime)
$path = $clPath

# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force
#Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and $null -eq (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer })} | Remove-Item -Force -Recurse
}

Import-Module GroupPolicy
$sMonth = Get-Date -format "MM"
$sDay = Get-Date -format "dd"
$sYear = Get-Date -format "yyyy"
$BUPath = "\\apachecorp\apps\IT\Backups\GPOs\" + $sYear + $sMonth + $sDay
#$jobFolder = "\\apachecorp\files\houston\resource\jobfiles\ad\"
$logPath = "\\apachecorp\apps\it\etc\scripts\logs\AD-PS-BackupGPOs"
if(Test-Path $logPath){} Else {New-item -Path "\\apachecorp\apps\it\etc\scripts\logs" -Name "AD-PS-BackupGPOs" -type directory}
$joblog = "\\apachecorp\apps\it\etc\Scripts\logs\AD-PS-BackupGPOs\AD-GPO-Backup-Transcript-" + $sYear + $sMonth + $sDay + ".log"
$errlog = "\\apachecorp\apps\it\etc\Scripts\logs\AD-PS-BackupGPOs\AD-GPO-Backup-" + $sYear + $sMonth + $sDay + ".log"
Start-Transcript $joblog
Try
{
$Time=Get-Date
"Starting GPO Backup Job at $Time" | out-file $errlog -append
if (Test-Path -Path $BUPath)
{}
Else
{New-Item $BUPath -type directory}
Backup-GPO -All -Path $BUPath -Domain apachecorp.com
}
Catch
{
    $_.ScriptStackTrace | Format-List -Force | out-file $errlog -append
    $_.Exception | Format-List -Force | out-file $errlog -append
}
Finally
{
    $Time=Get-Date
    "This script attempted to backup all GPOs at $Time" | out-file $errlog -append
}
$joblog = ""
ClearOldLogs $logPath -30
ClearOldLogs $BUPath -30
Stop-Transcript
# SIG # Begin signature block
# MIId/AYJKoZIhvcNAQcCoIId7TCCHekCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCTXEWVu/C2pd5S
# 3TeYofaOCLNPBnaRBjUTKwN2zYumgqCCDP0wggZDMIIFK6ADAgECAhM6AAAAApKq
# jDykbYmvAAAAAAACMA0GCSqGSIb3DQEBCwUAMC4xLDAqBgNVBAMTI0FwYWNoZSBS
# b290IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE5MDQxNTE4MDEzNFoXDTI5
# MDQxNTE4MTEzNFowZTETMBEGCgmSJomT8ixkARkWA2NvbTEaMBgGCgmSJomT8ixk
# ARkWCmFwYWNoZWNvcnAxMjAwBgNVBAMTKUFwYWNoZSBFbnRlcnByaXNlIENlcnRp
# ZmljYXRpb24gQXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
# AQEAx/Od555kmR7vcIOGwYq6W03Q1n9hxH8uIXDg5BaSwInbG1PlCVX9HPinmbYW
# uJ5qkvKOYm3/YI6K+NvsJ3rOsRwXF1/yqJxldv/VJzPeUzV2qjWj0uIdPCfGQcBE
# xJcJn43VeAY78iSpwnhX5TExS573P6NN5yfEOHvnCGHCVUOOt6X7s+mVw83WN+9F
# 9BQYuUzha5YgfvES4bikAzZg3MSnPkEwVyC3D9Pn3s0UDxJphom/4pyTxiqdshGr
# uykoL0A5QjQzYP2ZM17tP7bffkvJY1YlkXit1CTGFUTxiFQ1GPMI5xHGaAdi5mrh
# p+WAci/4ZiEsj/XoELthyezBYwIDAQABo4IDITCCAx0wEAYJKwYBBAGCNxUBBAMC
# AQAwHQYDVR0OBBYEFFQJkChFXu6HPBmsZKUQ9hpMEchBMBkGCSsGAQQBgjcUAgQM
# HgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1Ud
# IwQYMBaAFHZfzNx//qsRWgFIxq7c/QMR2sWeMIIBSQYDVR0fBIIBQDCCATwwggE4
# oIIBNKCCATCGgdhsZGFwOi8vL0NOPUFwYWNoZSUyMFJvb3QlMjBDZXJ0aWZpY2F0
# aW9uJTIwQXV0aG9yaXR5LENOPXVzd3Btc3RjYTAwMSxDTj1DRFAsQ049UHVibGlj
# JTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixE
# Qz1hcGFjaGVjb3JwLERDPWNvbT9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jh
# c2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnSGU2h0dHA6Ly9hcGFw
# a2kuYXBhY2hlY29ycC5jb20vQ2VydERhdGEvQXBhY2hlJTIwUm9vdCUyMENlcnRp
# ZmljYXRpb24lMjBBdXRob3JpdHkuY3JsMIIBQQYIKwYBBQUHAQEEggEzMIIBLzCB
# ywYIKwYBBQUHMAKGgb5sZGFwOi8vL0NOPUFwYWNoZSUyMFJvb3QlMjBDZXJ0aWZp
# Y2F0aW9uJTIwQXV0aG9yaXR5LENOPUFJQSxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2
# aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWFwYWNoZWNvcnAs
# REM9Y29tP2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0
# aW9uQXV0aG9yaXR5MF8GCCsGAQUFBzAChlNodHRwOi8vYXBhcGtpLmFwYWNoZWNv
# cnAuY29tL0NlcnREYXRhL0FwYWNoZSUyMFJvb3QlMjBDZXJ0aWZpY2F0aW9uJTIw
# QXV0aG9yaXR5LmNydDANBgkqhkiG9w0BAQsFAAOCAQEAL0E97JcPAJ1FDhdXsX7B
# ZgNww7FZlUI5CC5+nKTmPiTvq2BEEkjZRP+R2hOgHP/fcsZXIeTTm7p1RZSa/97l
# i1/fF1+22iQsC7DQfxHy5AMhXsgEvRAGeaGyXkkYchuD0nTIrLPUqwn7O7VrCObR
# zZXvt/6IEgsEEXO6NxExrJPpHiNDYghZx9j1Z6z1D50sEUDmB3I5HhUrgohTEOck
# 1o1PVaQPmVZSfrheheGlMJRk6TzpqMW8bwmraeNQgBtLYfEE+NeFNolYRk/eCiIQ
# 9HVvADnV5BuakDs92Dl+GMX4MD8ZH5ZCJI+bDHelWCA34CGGov3rol2t7q0Q3cmr
# 2jCCBrIwggWaoAMCAQICExoAAZ+rgQg2j9zB8oIAAAABn6swDQYJKoZIhvcNAQEL
# BQAwZTETMBEGCgmSJomT8ixkARkWA2NvbTEaMBgGCgmSJomT8ixkARkWCmFwYWNo
# ZWNvcnAxMjAwBgNVBAMTKUFwYWNoZSBFbnRlcnByaXNlIENlcnRpZmljYXRpb24g
# QXV0aG9yaXR5MB4XDTIwMDgxNDEzMTgzNFoXDTIzMDgxNDEzMTgzNFowUjELMAkG
# A1UEBhMCVVMxGzAZBgNVBAoTEkFwYWNoZSBDb3Jwb3JhdGlvbjELMAkGA1UECxMC
# SVQxGTAXBgNVBAMTEEFwYWNoZSBDb2RlIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUA
# A4IBDwAwggEKAoIBAQDCASH4o/OkhJM1KDsFq1lUnczdnVKE9pFEKTojXLtZtybm
# O4an2K3LEGtGAodHJW9m8nAi9Zy0IGBhXaWbh0yEDeKEPH/RUJFC4ARYTNErGYIR
# qTy4fpc/xfuoL1fQDQARl55YDvhwqezMWMUc48mhd0JuVVQnTFNE+JcICuoT+GG3
# uYk6YBsaHliAyD/j+wWAxLYVesfRvqITzQS2nmNYC7QifBI01uJAdjSSBe2ZEBLL
# RqRQkJKCF9nd1fEpn7SxhXffuimJf0rySENW19n92dXPQqv0+gy3A6JUHEnnzKaW
# 1SEpRKkWevsGAEQW8c0sTsqyiOE7kmwDgmTiLHr9AgMBAAGjggNsMIIDaDA9Bgkr
# BgEEAYI3FQcEMDAuBiYrBgEEAYI3FQiH56YIgc77LoX1lQyGpOAah7nfcYEDhrjg
# fIfHNwIBZAIBBDATBgNVHSUEDDAKBggrBgEFBQcDAzALBgNVHQ8EBAMCB4AwGwYJ
# KwYBBAGCNxUKBA4wDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUeNOlta9StfUPUlgf
# 4DI5LEfyCAgwHwYDVR0jBBgwFoAUVAmQKEVe7oc8GaxkpRD2GkwRyEEwggFVBgNV
# HR8EggFMMIIBSDCCAUSgggFAoIIBPIaB3mxkYXA6Ly8vQ049QXBhY2hlJTIwRW50
# ZXJwcmlzZSUyMENlcnRpZmljYXRpb24lMjBBdXRob3JpdHksQ049dXN3cG1zdGNh
# MDAyLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNl
# cyxDTj1Db25maWd1cmF0aW9uLERDPWFwYWNoZWNvcnAsREM9Y29tP2NlcnRpZmlj
# YXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRp
# b25Qb2ludIZZaHR0cDovL2FwYXBraS5hcGFjaGVjb3JwLmNvbS9DZXJ0RGF0YS9B
# cGFjaGUlMjBFbnRlcnByaXNlJTIwQ2VydGlmaWNhdGlvbiUyMEF1dGhvcml0eS5j
# cmwwggFNBggrBgEFBQcBAQSCAT8wggE7MIHRBggrBgEFBQcwAoaBxGxkYXA6Ly8v
# Q049QXBhY2hlJTIwRW50ZXJwcmlzZSUyMENlcnRpZmljYXRpb24lMjBBdXRob3Jp
# dHksQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2Vz
# LENOPUNvbmZpZ3VyYXRpb24sREM9YXBhY2hlY29ycCxEQz1jb20/Y0FDZXJ0aWZp
# Y2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwZQYI
# KwYBBQUHMAKGWWh0dHA6Ly9hcGFwa2kuYXBhY2hlY29ycC5jb20vQ2VydERhdGEv
# QXBhY2hlJTIwRW50ZXJwcmlzZSUyMENlcnRpZmljYXRpb24lMjBBdXRob3JpdHku
# Y3J0MA0GCSqGSIb3DQEBCwUAA4IBAQCROJRSuRz93X6lL0opsiK6d6RkX5z+uyba
# 3Ap5qWGFUZkyGqdhGzUBDcYNTyHjhoW0iicVGneWvrJOc1RVWp6PUO99NfMyZXxB
# PPN8zEf3EW7dgTEOCur5DsU6e7mGmWApzRENAR6hpJkiCiM02eOkZ+5qnCmNpxhf
# v9ZohsdVDmkk6DswUNHxKXeUovBOduf/nc7LvpxJ9N8Av/l1Yb5qucrPz3+D1ze2
# iPvkffzUfkrLIpigVfoWB1/h8iS0I2O1qKtFsoIcBjeOjU2VIGqbJpEn1uTRl6tv
# lI0ZiyQo5H0MgRX3i/tI4PUcm7X3ptz7DL8sxJdX8AOeGGQBypayMYIQVTCCEFEC
# AQEwfDBlMRMwEQYKCZImiZPyLGQBGRYDY29tMRowGAYKCZImiZPyLGQBGRYKYXBh
# Y2hlY29ycDEyMDAGA1UEAxMpQXBhY2hlIEVudGVycHJpc2UgQ2VydGlmaWNhdGlv
# biBBdXRob3JpdHkCExoAAZ+rgQg2j9zB8oIAAAABn6swDQYJYIZIAWUDBAIBBQCg
# fDAQBgorBgEEAYI3AgEMMQIwADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgbFof
# FXrtzKA9hKsnNoHYPL5dlMks29rvM6gN0VeJmHYwDQYJKoZIhvcNAQEBBQAEggEA
# XYyCCTFgwoqNJ1bFzwjcxa7VASSpun4x3hW1PVE7sByoWxnE+wUfJPgbvSePJG58
# FyqKDVv9ZVXuP0PU6UTHSH4Jym6xFTfR2h0ewFCK/A1Naehg8UvGjZgNdICcFr4P
# 1x2TR1T/d1seZ+OOPg64bmnBBs+Y2+85lp+d9vbeBcLVcJg3xqTvWv8H5OMQWEbB
# VQg6lgTazSZO66iNmtg9pZYCwwKHf6Xoux6K6XXtz/HcPWv4eMv9ZoufX0ZltT2/
# suqrLbp1KmoKmcPqnCNxQnPv0EAPf8PfQRy4EkATO4ofe9kTobHabPzlxOCljhcX
# oOlwauIUruMn/QZxrhZgiaGCDiwwgg4oBgorBgEEAYI3AwMBMYIOGDCCDhQGCSqG
# SIb3DQEHAqCCDgUwgg4BAgEDMQ0wCwYJYIZIAWUDBAIBMIH/BgsqhkiG9w0BCRAB
# BKCB7wSB7DCB6QIBAQYLYIZIAYb4RQEHFwMwITAJBgUrDgMCGgUABBQY6ZefEZZI
# 4vFDmYWFJZ1KyC1ilQIVAPbvHrapXaUGHQLrECM7idsS/rl+GA8yMDIxMDIxNzIw
# MzczN1owAwIBHqCBhqSBgzCBgDELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFu
# dGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3Jr
# MTEwLwYDVQQDEyhTeW1hbnRlYyBTSEEyNTYgVGltZVN0YW1waW5nIFNpZ25lciAt
# IEczoIIKizCCBTgwggQgoAMCAQICEHsFsdRJaFFE98mJ0pwZnRIwDQYJKoZIhvcN
# AQELBQAwgb0xCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5jLjEf
# MB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29yazE6MDgGA1UECxMxKGMpIDIw
# MDggVmVyaVNpZ24sIEluYy4gLSBGb3IgYXV0aG9yaXplZCB1c2Ugb25seTE4MDYG
# A1UEAxMvVmVyaVNpZ24gVW5pdmVyc2FsIFJvb3QgQ2VydGlmaWNhdGlvbiBBdXRo
# b3JpdHkwHhcNMTYwMTEyMDAwMDAwWhcNMzEwMTExMjM1OTU5WjB3MQswCQYDVQQG
# EwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5
# bWFudGVjIFRydXN0IE5ldHdvcmsxKDAmBgNVBAMTH1N5bWFudGVjIFNIQTI1NiBU
# aW1lU3RhbXBpbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7
# WZ1ZVU+djHJdGoGi61XzsAGtPHGsMo8Fa4aaJwAyl2pNyWQUSym7wtkpuS7sY7Ph
# zz8LVpD4Yht+66YH4t5/Xm1AONSRBudBfHkcy8utG7/YlZHz8O5s+K2WOS5/wSe4
# eDnFhKXt7a+Hjs6Nx23q0pi1Oh8eOZ3D9Jqo9IThxNF8ccYGKbQ/5IMNJsN7CD5N
# +Qq3M0n/yjvU9bKbS+GImRr1wOkzFNbfx4Dbke7+vJJXcnf0zajM/gn1kze+lYhq
# xdz0sUvUzugJkV+1hHk1inisGTKPI8EyQRtZDqk+scz51ivvt9jk1R1tETqS9pPJ
# nONI7rtTDtQ2l4Z4xaE3AgMBAAGjggF3MIIBczAOBgNVHQ8BAf8EBAMCAQYwEgYD
# VR0TAQH/BAgwBgEB/wIBADBmBgNVHSAEXzBdMFsGC2CGSAGG+EUBBxcDMEwwIwYI
# KwYBBQUHAgEWF2h0dHBzOi8vZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBka
# F2h0dHBzOi8vZC5zeW1jYi5jb20vcnBhMC4GCCsGAQUFBwEBBCIwIDAeBggrBgEF
# BQcwAYYSaHR0cDovL3Muc3ltY2QuY29tMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6
# Ly9zLnN5bWNiLmNvbS91bml2ZXJzYWwtcm9vdC5jcmwwEwYDVR0lBAwwCgYIKwYB
# BQUHAwgwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0yMDQ4LTMw
# HQYDVR0OBBYEFK9j1sqjToVy4Ke8QfMpojh/gHViMB8GA1UdIwQYMBaAFLZ3+mlI
# R59TEtXC6gcydgfRlwcZMA0GCSqGSIb3DQEBCwUAA4IBAQB16rAt1TQZXDJF/g7h
# 1E+meMFv1+rd3E/zociBiPenjxXmQCmt5l30otlWZIRxMCrdHmEXZiBWBpgZjV1x
# 8viXvAn9HJFHyeLojQP7zJAv1gpsTjPs1rSTyEyQY0g5QCHE3dZuiZg8tZiX6KkG
# twnJj1NXQZAv4R5NTtzKEHhsQm7wtsX4YVxS9U72a433Snq+8839A9fZ9gOoD+NT
# 9wp17MZ1LqpmhQSZt/gGV+HGDvbor9rsmxgfqrnjOgC/zoqUywHbnsc4uw9Sq9Hj
# lANgCk2g/idtFDL8P5dA4b+ZidvkORS92uTTw+orWrOVWFUEfcea7CMDjYUq0v+u
# qWGBMIIFSzCCBDOgAwIBAgIQe9Tlr7rMBz+hASMEIkFNEjANBgkqhkiG9w0BAQsF
# ADB3MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24x
# HzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxKDAmBgNVBAMTH1N5bWFu
# dGVjIFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwHhcNMTcxMjIzMDAwMDAwWhcNMjkw
# MzIyMjM1OTU5WjCBgDELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENv
# cnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMTEwLwYD
# VQQDEyhTeW1hbnRlYyBTSEEyNTYgVGltZVN0YW1waW5nIFNpZ25lciAtIEczMIIB
# IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArw6Kqvjcv2l7VBdxRwm9jTyB
# +HQVd2eQnP3eTgKeS3b25TY+ZdUkIG0w+d0dg+k/J0ozTm0WiuSNQI0iqr6nCxvS
# B7Y8tRokKPgbclE9yAmIJgg6+fpDI3VHcAyzX1uPCB1ySFdlTa8CPED39N0yOJM/
# 5Sym81kjy4DeE035EMmqChhsVWFX0fECLMS1q/JsI9KfDQ8ZbK2FYmn9ToXBilIx
# q1vYyXRS41dsIr9Vf2/KBqs/SrcidmXs7DbylpWBJiz9u5iqATjTryVAmwlT8ClX
# hVhe6oVIQSGH5d600yaye0BTWHmOUjEGTZQDRcTOPAPstwDyOiLFtG/l77CKmwID
# AQABo4IBxzCCAcMwDAYDVR0TAQH/BAIwADBmBgNVHSAEXzBdMFsGC2CGSAGG+EUB
# BxcDMEwwIwYIKwYBBQUHAgEWF2h0dHBzOi8vZC5zeW1jYi5jb20vY3BzMCUGCCsG
# AQUFBwICMBkaF2h0dHBzOi8vZC5zeW1jYi5jb20vcnBhMEAGA1UdHwQ5MDcwNaAz
# oDGGL2h0dHA6Ly90cy1jcmwud3Muc3ltYW50ZWMuY29tL3NoYTI1Ni10c3MtY2Eu
# Y3JsMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMA4GA1UdDwEB/wQEAwIHgDB3Bggr
# BgEFBQcBAQRrMGkwKgYIKwYBBQUHMAGGHmh0dHA6Ly90cy1vY3NwLndzLnN5bWFu
# dGVjLmNvbTA7BggrBgEFBQcwAoYvaHR0cDovL3RzLWFpYS53cy5zeW1hbnRlYy5j
# b20vc2hhMjU2LXRzcy1jYS5jZXIwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRp
# bWVTdGFtcC0yMDQ4LTYwHQYDVR0OBBYEFKUTAamfhcwbbhYeXzsxqnk2AHsdMB8G
# A1UdIwQYMBaAFK9j1sqjToVy4Ke8QfMpojh/gHViMA0GCSqGSIb3DQEBCwUAA4IB
# AQBGnq/wuKJfoplIz6gnSyHNsrmmcnBjL+NVKXs5Rk7nfmUGWIu8V4qSDQjYELo2
# JPoKe/s702K/SpQV5oLbilRt/yj+Z89xP+YzCdmiWRD0Hkr+Zcze1GvjUil1AEor
# pczLm+ipTfe0F1mSQcO3P4bm9sB/RDxGXBda46Q71Wkm1SF94YBnfmKst04uFZrl
# nCOvWxHqcalB+Q15OKmhDc+0sdo+mnrHIsV0zd9HCYbE/JElshuW6YUI6N3qdGBu
# YKVWeg3IRFjc5vlIFJ7lv94AvXexmBRyFCTfxxEsHwA/w0sUxmcczB4Go5BfXFSL
# PuMzW4IPxbeGAk5xn+lmRT92MYICWjCCAlYCAQEwgYswdzELMAkGA1UEBhMCVVMx
# HTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRl
# YyBUcnVzdCBOZXR3b3JrMSgwJgYDVQQDEx9TeW1hbnRlYyBTSEEyNTYgVGltZVN0
# YW1waW5nIENBAhB71OWvuswHP6EBIwQiQU0SMAsGCWCGSAFlAwQCAaCBpDAaBgkq
# hkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTIxMDIxNzIw
# MzczN1owLwYJKoZIhvcNAQkEMSIEIPKd+uwUUqofoAvzkrPTG9YWvwq0226cYRM8
# cS1JjfplMDcGCyqGSIb3DQEJEAIvMSgwJjAkMCIEIMR0znYAfQI5Tg2l5N58FMaA
# +eKCATz+9lPvXbcf32H4MAsGCSqGSIb3DQEBAQSCAQBk7ERRZ1f+K1iHJcGwgPMx
# uzSPZQEpgbEaquL/wXovfhBA6tR93Xt20fe/zgKnXafz4O0gQxqeyjW2H+D3hFWl
# TG808Uua4mG1iW7QUJSc9FL9HDdK2EJ4UjSzSBeBWJCrnTwS9zHQamTTO3jG2Gtv
# HH/RgKrtQMsmM6ygA0AkHJYND2ACz8IqCXFO8hiX7ZXLtd/leH+MrL1UwCu6hS6Z
# ZptedYcyCMMnqz4zSpmY8qN+GQYb1J82k2vq5CO21aHZEFOpJ0okZIffA74AVPxb
# 0Ut7JbpSNHrEm25Ag35nkuFhQtzPED0pTEthIW1J1SrMOmnZLRE7YOWa82CzWq3V
# SIG # End signature block
