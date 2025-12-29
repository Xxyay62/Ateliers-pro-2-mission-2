# Définir le nouveau domaine
$nouveauDC = "DC=entreprise2,DC=local"

# Liste des OU à créer
$ouList = @(
    "OU=Domain Controllers,$nouveauDC",
    "OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Groupes,OU=Client AuditMe,$nouveauDC",
    "OU=Ressources Humaines,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Service Informatique,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Administratifs,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Marketing,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Comptabilité,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Client AuditMe,$nouveauDC",
    "OU=Ordinateurs,OU=Client AuditMe,$nouveauDC",
    "OU=GLocales,OU=Groupes,OU=Client AuditMe,$nouveauDC",
    "OU=GGlobales,OU=Groupes,OU=Client AuditMe,$nouveauDC",
    "OU=Employés,OU=Administratifs,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Responsables,OU=Administratifs,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Employés,OU=Comptabilité,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Responsables,OU=Comptabilité,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Employés,OU=Marketing,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Responsables,OU=Marketing,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Employés,OU=Ressources Humaines,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Responsables,OU=Ressources Humaines,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC",
    "OU=Techniciens,OU=Service Informatique,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"
)

# Création des OU
foreach ($ou in $ouList) {
    New-ADOrganizationalUnit -Name ($ou -split ",")[0].Replace("OU=", "") -Path ($ou -replace "^OU=[^,]+,", "") -ErrorAction SilentlyContinue
}

# Mot de passe commun
$pwd = ConvertTo-SecureString "Sio1234*" -AsPlainText -Force

# Création des utilisateurs
$users = @(
    @{Name="Administrateur"; Sam="Administrateur"; Path="OU=Service Informatique,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"},
    @{Name="User1"; Sam="User1"; Path="OU=Employés,OU=Administratifs,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"},
    @{Name="User2"; Sam="User2"; Path="OU=Responsables,OU=Administratifs,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"},
    @{Name="User3"; Sam="User3"; Path="OU=Employés,OU=Comptabilité,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"},
    @{Name="User4"; Sam="User4"; Path="OU=Responsables,OU=Comptabilité,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"},
    @{Name="User5"; Sam="User5"; Path="OU=Employés,OU=Marketing,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"},
    @{Name="User6"; Sam="User6"; Path="OU=Responsables,OU=Marketing,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"},
    @{Name="User7"; Sam="User7"; Path="OU=Employés,OU=Ressources Humaines,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"},
    @{Name="User8"; Sam="User8"; Path="OU=Responsables,OU=Ressources Humaines,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"},
    @{Name="User9"; Sam="User9"; Path="OU=Techniciens,OU=Service Informatique,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"},
    @{Name="User10"; Sam="User10"; Path="OU=Administrateurs,OU=Service Informatique,OU=Utilisateurs,OU=Client AuditMe,$nouveauDC"}
)

foreach ($u in $users) {
    New-ADUser -Name $u.Name -SamAccountName $u.Sam -Path $u.Path -AccountPassword $pwd -Enabled $true -ErrorAction SilentlyContinue
}

