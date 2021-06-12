$global:mainDirPath = "C:\Users\tomas\main"
$global:gnuBinPath = "$env:ProgramFiles\Git\usr\bin"

Function Set-LocationDownloads {Set-Location "$env:USERPROFILE\Downloads"}

Function Set-LocationGit {Set-Location "$global:mainDirPath\git"}

Function Set-LocationMain {Set-Location $global:mainDirPath}

Function Set-LocationWorkshop {Set-Location "$global:mainDirPath\workshop"}

Function Open-TotalCommander {param([string] $path = $(Get-Location)) & "$env:ProgramFiles\totalcmd\TOTALCMD64.EXE" /O /L $path /P=L}

Function Get-MarksFilePath {return "$env:USERPROFILE\marks.xml"}

Function Get-DefaultMarkName {return "(default)"}

Function Get-Marks {
    try {
        return Import-CliXML (Get-MarksFilePath) 
    }
    catch [System.IO.FileNotFoundException] {
        return @{}
    }
}

Function Set-Marks {
    param($marks)
    Export-Clixml -Path (Get-MarksFilePath) -InputObject $marks
}

Function Set-Mark {
    param([string] $alias = (Get-DefaultMarkName))
    $marks = Get-Marks
    $marks[$alias] = $(Get-Location).Path
    Set-Marks $marks
}

Function Open-Mark {
    param([string] $alias = (Get-DefaultMarkName))
    $marks = Get-Marks
    $location = $marks[$alias]
    if ($location) {
        Set-Location $location
    } else {
        Write-Error "Undefined location '$alias', use Get-Marks to get list of defined locations"
    }
}

Function Remove-Mark {
    param([string] $alias = (Get-DefaultMarkName))
    $marks = Get-Marks
    $marks.Remove($alias)
    Set-Marks $marks
}

Function Set-Title {param([string] $title = (Get-Location).Path) $Host.UI.RawUI.WindowTitle = $title}

Set-Alias -Name cdd -Value Set-LocationDownloads
Set-Alias -Name cdg -Value Set-LocationGit
Set-Alias -Name cdm -Value Set-LocationMain
Set-Alias -Name cdw -Value Set-LocationWorkshop

# Programs
Set-Alias -Name tc -Value Open-TotalCommander
Set-Alias -Name inkscape -Value "$env:ProgramFiles\Inkscape\inkscape.exe"

# GNU aliases
Set-Alias -Name diff -Value "$gnuBinPath\diff.exe" -Force
Set-Alias -Name find -Value "$gnuBinPath\find.exe"
Set-Alias -Name vim -Value "$gnuBinPath\vim.exe"

# Mark & Recall
Set-Alias -Name m -Value Set-Mark
Set-Alias -Name r -Value Open-Mark
Set-Alias -Name d -Value Remove-Mark
Set-Alias -Name l -Value Get-Marks

Set-Alias -Name t -Value Set-Title

Import-Module -Name posh-git

