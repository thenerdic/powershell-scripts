$userName = Read-Host -Prompt "Name"
$userGiveName = Read-Host -Prompt "GivenName"
$userSurname = Read-Host -Prompt "Surname"
$userDisplayName = Read-Host -Prompt "Display Name"
$userOU = Read-Host -Prompt "Organizational Unit"
$userPrincipalName = Read-Host -Prompt "Principal Name"
$userPassword = Read-Host -Prompt "Password" -AsSecureString
$userSamName = $userPrincipalName

# organizational unit
$ouPath = "OU=$userOU,DC=evilcorp,DC=local"
$ouExists = Get-ADOrganizationalUnit -Filter { DistinguishedName -eq $ouPath } -ErrorAction SilentlyContinue

# check if OU exists
if (-not $ouExists) {
    Write-Output "OU does not exist. Creating OU...$userOU"

    # create OU
    New-ADOrganizationalUnit -Name $userOU -Path "DC=evilcorp,DC=local"
    Write-Output "OU '$userOU' created successfully"
}

$user = @{
    Name = $userName
    GivenName = $userGiveName
    Surname = $userSurname
    DisplayName = $userDisplayName
    Path = "OU=$userOU,DC=evilcorp,DC=local"
    UserPrincipalName = "$userPrincipalName@evilcorp.local"
    AccountPassword = $userPassword
    SamAccountName = $userSamName
    ChangePasswordAtLogon = $true
}

New-ADUser @user