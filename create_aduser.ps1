$userName = Read-Host -Prompt "Name"
$userGiveName = Read-Host -Prompt "GivenName"
$userSurname = Read-Host -Prompt "Surname"
$userOU = Read-Host -Prompt "Organizational Unit"
$userPrincipalName = Read-Host -Prompt "Principal Name"
$userPassword = Read-Host -Prompt "Password" -AsSecureString

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
    Path = "OU=$userOU,DC=evilcorp,DC=local"
    UserPrincipalName = "$userPrincipalName@evilcorp.local"
    AccountPassword = $userPassword
    ChangePasswordAtLogon = $true
}

New-ADUser @user