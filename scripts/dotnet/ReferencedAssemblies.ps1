param(
[string]$dllPath,
[switch]$verbose
)

Get-ChildItem -Recurse -Path $dllPath -Filter *.dll | 
Foreach-Object {
    $fullName = $_.FullName

    if ($verbose)
    {
        Write-Output "`n`n================================================================================"
        Write-Output "Processing $($_.FullName)"
    }

    $currentAssembly = [Reflection.Assembly]::LoadFile($fullName)
    $currentAssemblyName = New-Object System.Reflection.AssemblyName($currentAssembly.FullName)
    $currentAssemblyVersion = $currentAssemblyName.Version

    if ($verbose)
    {
        Write-Output "`nAssembly Full Name:   $($currentAssembly.FullName)"
        Write-Output "Assembly Version:     $($currentAssemblyVersion)"
    }

    $referencedAssemblies = $currentAssembly.GetReferencedAssemblies() | Sort-Object -Property Name

    Write-Output "Referenced Assemblies: "

    foreach ($assembly in $referencedAssemblies) {
        Write-Output $assembly
    }
}
