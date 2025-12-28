Import-Module ActiveDirectory

# ==========================
# Fonctions utilitaires
# ==========================
function New-IfNotExists-Group {
    param($Name, $Path, $Scope, $Description = "")
    $dn = "CN=$Name,$Path"
    if (-not (Get-ADGroup -LDAPFilter "(distinguishedName=$dn)" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $Name -GroupScope $Scope -GroupCategory Security -Path $Path -Description $Description
        Write-Host "[GL] Créé : $Name"
    } else {
        Write-Host "[GL] Existe déjà : $Name"
    }
}

function Set-NTFSPermission {
    param($Folder, $Group, $Access)

    $acl = Get-Acl $Folder
    $identity = "$env:USERDOMAIN\$Group"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($identity, $Access, "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($rule)
    Set-Acl -Path $Folder -AclObject $acl
    Write-Host "[ACL] $Group → $Access sur $Folder"
}

# ==========================
# Paramètres
# ==========================
$glPath = "OU=Groupes locaux ressources,OU=Service IT,OU=Client ValorElec,DC=entreprise2,DC=local"

# Dossiers et droits
$structure = @{
    "D:\Partage1\AuditMe" = @("Administratifs", "Comptabilité", "Marketing", "Ressources Humaines", "Direction", "Commercial", "RD", "Informatique")
    "D:\Partage2\ValorElec" = @("Direction", "Commercial", "RD", "Service IT")
}

# ==========================
# Traitement
# ==========================
foreach ($base in $structure.Keys) {

    $client = Split-Path $base -Leaf
    $services = $structure[$base]

    foreach ($service in $services) {

        $folder = Join-Path $base $service

        # Création des GL
        $gl_LE = "GL-$client-$service-LE"
        $gl_LM = "GL-$client-$service-LM"
        $gl_CT = "GL-$client-$service-CT"

        New-IfNotExists-Group $gl_LE $glPath "DomainLocal" "Lecture/Écriture - $service $client"
        New-IfNotExists-Group $gl_LM $glPath "DomainLocal" "Lecture/Modification - $service $client"
        New-IfNotExists-Group $gl_CT $glPath "DomainLocal" "Contrôle total - $service $client"

        # Application des ACL NTFS
        if (Test-Path $folder) {
            Set-NTFSPermission -Folder $folder -Group $gl_LE -Access "ReadAndExecute"
            Set-NTFSPermission -Folder $folder -Group $gl_LM -Access "Modify"
            Set-NTFSPermission -Folder $folder -Group $gl_CT -Access "FullControl"
        } else {
            Write-Host "[SKIP] Dossier introuvable : $folder"
        }
    }
}
