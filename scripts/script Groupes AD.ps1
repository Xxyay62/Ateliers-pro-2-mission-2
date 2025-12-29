# Définir le chemin des OU
$pathGG = "OU=GGlobales,OU=Groupes,OU=Client AuditMe,DC=entreprise2,DC=local"
$pathGL = "OU=GLocales,OU=Groupes,OU=Client AuditMe,DC=entreprise2,DC=local"

$ggList = @(
    "Gg_Service_Informatique",
    "Gg_Comptabilité",
    "Gg_Marketing",
    "Gg_Administratifs",
    "Gg_Ressources_Humaines",
    "Gg_Administrateurs_Informatiques",
    "Gg_Techniciens_informatiques",
    "Gg_Comptabilité_Employés",
    "Gg_Comptabilité_Responsables",
    "Gg_Marketing_responsables",
    "Gg_Marketing_Employés",
    "Gg_Administratifs_Responsables",
    "Gg_Administratifs_Employés",
    "Gg_Ressources_Humaines_Responsables",
    "Gg_Ressources_Humaines_Employés"
)

foreach ($gg in $ggList) {
    New-ADGroup -Name $gg -GroupScope Global -GroupCategory Security -Path "OU=GGlobales,OU=Groupes,OU=Client AuditMe,DC=entreprise2,DC=local" -ErrorAction SilentlyContinue
}

$glList = @(
    "DL_Echanges_LM",
    "DL_Echanges_L",
    "DL_Echanges_CT",
    "DL_RH_LM",
    "DL_RH_L",
    "DL_RH_CT",
    "DL_SI_LM",
    "DL_SI_CT",
    "DL_ADM_LM",
    "DL_ADM_CT",
    "DL_MARK_LM",
    "DL_MARK_L",
    "DL_ADM_CT2",
    "DL_COM_LM",
    "DL_COM_CT"
)

foreach ($gl in $glList) {
    New-ADGroup -Name $gl -GroupScope DomainLocal -GroupCategory Security -Path "OU=GLocales,OU=Groupes,OU=Client AuditMe,DC=entreprise2,DC=local" -ErrorAction SilentlyContinue
}

# Affectations selon le tableau
$affectations = @{
    "DL_Echanges_LM" = @("Gg_Service_Informatique", "Gg_Comptabilité", "Gg_Marketing", "Gg_Administratifs", "Gg_Ressources_Humaines")
    "DL_Echanges_L"  = @("Gg_Comptabilité", "Gg_Marketing", "Gg_Administratifs", "Gg_Ressources_Humaines")
    "DL_Echanges_CT" = @("Gg_Comptabilité", "Gg_Marketing", "Gg_Administratifs", "Gg_Ressources_Humaines")
    "DL_RH_LM"        = @("Gg_Ressources_Humaines", "Gg_Ressources_Humaines_Responsables", "Gg_Ressources_Humaines_Employés")
    "DL_RH_L"         = @("Gg_Ressources_Humaines", "Gg_Ressources_Humaines_Responsables", "Gg_Ressources_Humaines_Employés")
    "DL_RH_CT"        = @("Gg_Ressources_Humaines", "Gg_Ressources_Humaines_Responsables", "Gg_Ressources_Humaines_Employés")
    "DL_SI_LM"        = @("Gg_Service_Informatique", "Gg_Administrateurs_Informatiques", "Gg_Techniciens_informatiques")
    "DL_SI_CT"        = @("Gg_Service_Informatique", "Gg_Administrateurs_Informatiques", "Gg_Techniciens_informatiques")
    "DL_ADM_LM"       = @("Gg_Administratifs", "Gg_Administratifs_Responsables", "Gg_Administratifs_Employés")
    "DL_ADM_CT"       = @("Gg_Administratifs", "Gg_Administratifs_Responsables", "Gg_Administratifs_Employés")
    "DL_MARK_LM"      = @("Gg_Marketing", "Gg_Marketing_responsables", "Gg_Marketing_Employés")
    "DL_MARK_L"       = @("Gg_Marketing", "Gg_Marketing_responsables", "Gg_Marketing_Employés")
    "DL_ADM_CT2"      = @("Gg_Administratifs_Responsables", "Gg_Administratifs_Employés")
    "DL_COM_LM"       = @("Gg_Comptabilité", "Gg_Comptabilité_Responsables", "Gg_Comptabilité_Employés")
    "DL_COM_CT"       = @("Gg_Comptabilité", "Gg_Comptabilité_Responsables", "Gg_Comptabilité_Employés")
}

foreach ($gl in $affectations.Keys) {
    foreach ($gg in $affectations[$gl]) {
        Add-ADGroupMember -Identity $gl -Members $gg -ErrorAction SilentlyContinue
    }
}