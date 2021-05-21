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
BUPath = "\\apachecorp\apps\IT\Backups\GPOs\" + $sYear + $sMonth + $sDay
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
ClearOldLogs $BUPath -90
Stop-Transcript
# SIG # Begin signature block
# MIId+wYJKoZIhvcNAQcCoIId7DCCHegCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAFSq6tv+CSag51
# 8hPckqXY4kdbXWlV4EqtnbRKMOGP4qCCDP0wggZDMIIFK6ADAgECAhM6AAAAApKq
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
# lI0ZiyQo5H0MgRX3i/tI4PUcm7X3ptz7DL8sxJdX8AOeGGQBypayMYIQVDCCEFAC
# AQEwfDBlMRMwEQYKCZImiZPyLGQBGRYDY29tMRowGAYKCZImiZPyLGQBGRYKYXBh
# Y2hlY29ycDEyMDAGA1UEAxMpQXBhY2hlIEVudGVycHJpc2UgQ2VydGlmaWNhdGlv
# biBBdXRob3JpdHkCExoAAZ+rgQg2j9zB8oIAAAABn6swDQYJYIZIAWUDBAIBBQCg
# fDAQBgorBgEEAYI3AgEMMQIwADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgviZU
# +5g5ylAJGiNwJnpEyTp4faMTv0RQJMvqFPYlbqEwDQYJKoZIhvcNAQEBBQAEggEA
# U2scxNg75JKCzoX0eNSkKpgGpGc31Q3PWPHA/1rLGnItx69/tVZnRJbKoNbjrSWQ
# 4aAtuoJ4xtIenuPisGRTlxAJAtwGSnKNw00S9T+XzSq9CGqTK47zb/ZNSmA0Njtj
# EjaexBBAOyDRQ1Lkt2JTgm0NU13Gq5GRvamMBzC2Wp/7E82LcfgGIpt5QtEks2fF
# 1W+UBDSP1Ailxsv/5S2pZXvoNP2nWPTDWN20potQDRoVyT5pKdTkxyI7vkW3dn+Q
# TreJXYPU+wyvzdAaE2k7cHIGb4Qu6wfbV47pRZ+PZjEpa8HZDDqMnxvVSNXdNmPa
# Wb7IRZCQ9zraDDF6tY7viaGCDiswgg4nBgorBgEEAYI3AwMBMYIOFzCCDhMGCSqG
# SIb3DQEHAqCCDgQwgg4AAgEDMQ0wCwYJYIZIAWUDBAIBMIH+BgsqhkiG9w0BCRAB
# BKCB7gSB6zCB6AIBAQYLYIZIAYb4RQEHFwMwITAJBgUrDgMCGgUABBRux4skRYVm
# J3nHI1ICGDImPgv43gIUJzXB3Zc4G0RWwPd1FjCgFfWJYxwYDzIwMjAxMTE3MjIy
# MDM2WjADAgEeoIGGpIGDMIGAMQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50
# ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsx
# MTAvBgNVBAMTKFN5bWFudGVjIFNIQTI1NiBUaW1lU3RhbXBpbmcgU2lnbmVyIC0g
# RzOgggqLMIIFODCCBCCgAwIBAgIQewWx1EloUUT3yYnSnBmdEjANBgkqhkiG9w0B
# AQsFADCBvTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8w
# HQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTowOAYDVQQLEzEoYykgMjAw
# OCBWZXJpU2lnbiwgSW5jLiAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MTgwNgYD
# VQQDEy9WZXJpU2lnbiBVbml2ZXJzYWwgUm9vdCBDZXJ0aWZpY2F0aW9uIEF1dGhv
# cml0eTAeFw0xNjAxMTIwMDAwMDBaFw0zMTAxMTEyMzU5NTlaMHcxCzAJBgNVBAYT
# AlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3lt
# YW50ZWMgVHJ1c3QgTmV0d29yazEoMCYGA1UEAxMfU3ltYW50ZWMgU0hBMjU2IFRp
# bWVTdGFtcGluZyBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALtZ
# nVlVT52Mcl0agaLrVfOwAa08cawyjwVrhponADKXak3JZBRLKbvC2Sm5Luxjs+HP
# PwtWkPhiG37rpgfi3n9ebUA41JEG50F8eRzLy60bv9iVkfPw7mz4rZY5Ln/BJ7h4
# OcWEpe3tr4eOzo3HberSmLU6Hx45ncP0mqj0hOHE0XxxxgYptD/kgw0mw3sIPk35
# CrczSf/KO9T1sptL4YiZGvXA6TMU1t/HgNuR7v68kldyd/TNqMz+CfWTN76ViGrF
# 3PSxS9TO6AmRX7WEeTWKeKwZMo8jwTJBG1kOqT6xzPnWK++32OTVHW0ROpL2k8mc
# 40juu1MO1DaXhnjFoTcCAwEAAaOCAXcwggFzMA4GA1UdDwEB/wQEAwIBBjASBgNV
# HRMBAf8ECDAGAQH/AgEAMGYGA1UdIARfMF0wWwYLYIZIAYb4RQEHFwMwTDAjBggr
# BgEFBQcCARYXaHR0cHM6Ly9kLnN5bWNiLmNvbS9jcHMwJQYIKwYBBQUHAgIwGRoX
# aHR0cHM6Ly9kLnN5bWNiLmNvbS9ycGEwLgYIKwYBBQUHAQEEIjAgMB4GCCsGAQUF
# BzABhhJodHRwOi8vcy5zeW1jZC5jb20wNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDov
# L3Muc3ltY2IuY29tL3VuaXZlcnNhbC1yb290LmNybDATBgNVHSUEDDAKBggrBgEF
# BQcDCDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMzAd
# BgNVHQ4EFgQUr2PWyqNOhXLgp7xB8ymiOH+AdWIwHwYDVR0jBBgwFoAUtnf6aUhH
# n1MS1cLqBzJ2B9GXBxkwDQYJKoZIhvcNAQELBQADggEBAHXqsC3VNBlcMkX+DuHU
# T6Z4wW/X6t3cT/OhyIGI96ePFeZAKa3mXfSi2VZkhHEwKt0eYRdmIFYGmBmNXXHy
# +Je8Cf0ckUfJ4uiNA/vMkC/WCmxOM+zWtJPITJBjSDlAIcTd1m6JmDy1mJfoqQa3
# CcmPU1dBkC/hHk1O3MoQeGxCbvC2xfhhXFL1TvZrjfdKer7zzf0D19n2A6gP41P3
# CnXsxnUuqmaFBJm3+AZX4cYO9uiv2uybGB+queM6AL/OipTLAduexzi7D1Kr0eOU
# A2AKTaD+J20UMvw/l0Dhv5mJ2+Q5FL3a5NPD6itas5VYVQR9x5rsIwONhSrS/66p
# YYEwggVLMIIEM6ADAgECAhB71OWvuswHP6EBIwQiQU0SMA0GCSqGSIb3DQEBCwUA
# MHcxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEf
# MB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEoMCYGA1UEAxMfU3ltYW50
# ZWMgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTAeFw0xNzEyMjMwMDAwMDBaFw0yOTAz
# MjIyMzU5NTlaMIGAMQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29y
# cG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxMTAvBgNV
# BAMTKFN5bWFudGVjIFNIQTI1NiBUaW1lU3RhbXBpbmcgU2lnbmVyIC0gRzMwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvDoqq+Ny/aXtUF3FHCb2NPIH4
# dBV3Z5Cc/d5OAp5LdvblNj5l1SQgbTD53R2D6T8nSjNObRaK5I1AjSKqvqcLG9IH
# tjy1GiQo+BtyUT3ICYgmCDr5+kMjdUdwDLNfW48IHXJIV2VNrwI8QPf03TI4kz/l
# LKbzWSPLgN4TTfkQyaoKGGxVYVfR8QIsxLWr8mwj0p8NDxlsrYViaf1OhcGKUjGr
# W9jJdFLjV2wiv1V/b8oGqz9KtyJ2ZezsNvKWlYEmLP27mKoBONOvJUCbCVPwKVeF
# WF7qhUhBIYfl3rTTJrJ7QFNYeY5SMQZNlANFxM48A+y3API6IsW0b+XvsIqbAgMB
# AAGjggHHMIIBwzAMBgNVHRMBAf8EAjAAMGYGA1UdIARfMF0wWwYLYIZIAYb4RQEH
# FwMwTDAjBggrBgEFBQcCARYXaHR0cHM6Ly9kLnN5bWNiLmNvbS9jcHMwJQYIKwYB
# BQUHAgIwGRoXaHR0cHM6Ly9kLnN5bWNiLmNvbS9ycGEwQAYDVR0fBDkwNzA1oDOg
# MYYvaHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vc2hhMjU2LXRzcy1jYS5j
# cmwwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQDAgeAMHcGCCsG
# AQUFBwEBBGswaTAqBggrBgEFBQcwAYYeaHR0cDovL3RzLW9jc3Aud3Muc3ltYW50
# ZWMuY29tMDsGCCsGAQUFBzAChi9odHRwOi8vdHMtYWlhLndzLnN5bWFudGVjLmNv
# bS9zaGEyNTYtdHNzLWNhLmNlcjAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGlt
# ZVN0YW1wLTIwNDgtNjAdBgNVHQ4EFgQUpRMBqZ+FzBtuFh5fOzGqeTYAex0wHwYD
# VR0jBBgwFoAUr2PWyqNOhXLgp7xB8ymiOH+AdWIwDQYJKoZIhvcNAQELBQADggEB
# AEaer/C4ol+imUjPqCdLIc2yuaZycGMv41UpezlGTud+ZQZYi7xXipINCNgQujYk
# +gp7+zvTYr9KlBXmgtuKVG3/KP5nz3E/5jMJ2aJZEPQeSv5lzN7Ua+NSKXUASiul
# zMub6KlN97QXWZJBw7c/hub2wH9EPEZcF1rjpDvVaSbVIX3hgGd+Yqy3Ti4VmuWc
# I69bEepxqUH5DXk4qaENz7Sx2j6aescixXTN30cJhsT8kSWyG5bphQjo3ep0YG5g
# pVZ6DchEWNzm+UgUnuW/3gC9d7GYFHIUJN/HESwfAD/DSxTGZxzMHgajkF9cVIs+
# 4zNbgg/Ft4YCTnGf6WZFP3YxggJaMIICVgIBATCBizB3MQswCQYDVQQGEwJVUzEd
# MBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVj
# IFRydXN0IE5ldHdvcmsxKDAmBgNVBAMTH1N5bWFudGVjIFNIQTI1NiBUaW1lU3Rh
# bXBpbmcgQ0ECEHvU5a+6zAc/oQEjBCJBTRIwCwYJYIZIAWUDBAIBoIGkMBoGCSqG
# SIb3DQEJAzENBgsqhkiG9w0BCRABBDAcBgkqhkiG9w0BCQUxDxcNMjAxMTE3MjIy
# MDM2WjAvBgkqhkiG9w0BCQQxIgQgl9rM3avwOBowauizsmccnkqsPOOPHDaE+oRq
# a6RqbsYwNwYLKoZIhvcNAQkQAi8xKDAmMCQwIgQgxHTOdgB9AjlODaXk3nwUxoD5
# 4oIBPP72U+9dtx/fYfgwCwYJKoZIhvcNAQEBBIIBAC2JO+TxpmktDv4K571DRBfL
# f80nz2TaEBJu1XnG2lQjKD5WphCcsWMWxAZKfFK75lvGLfBW8H9OaOvTqKIqR100
# gg9vT4Jw47ZaTwLEtvExRXtqvV/UJ8JD09FWb7gJlt6N3C4L6uXyyBxC1sB3q0E6
# NvFGXMI02r373kiuJRjHAnUZ+Foc0t+ky4kKvi8VG69hORJvh15QlBbCXjnCdEt3
# UFwMxvu3H+SdOR/0bZ54R0hteDXT7MiDA6UwqoLOy/b5yAqv1OUqNN+EVDl/n8Je
# VO4FZXMz4HZ8QertDLGTzfeCyTjbWzWszt0OpLE5eqSxW6GlKktz9ZMkdxrpls4=
# SIG # End signature block
