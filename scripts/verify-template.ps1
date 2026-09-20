param(
    [string]$OverleafDir = (Join-Path $PSScriptRoot '..\overleaf')
)

$ErrorActionPreference = 'Stop'
$overleafRoot = (Resolve-Path -LiteralPath $OverleafDir).Path

function Remove-TeXComments {
    param([string]$Text)

    $strippedLines = foreach ($line in ($Text -split "`r?`n")) {
        $commentIndex = $line.Length
        $backslashCount = 0

        for ($index = 0; $index -lt $line.Length; $index++) {
            if ($line[$index] -eq '\') {
                $backslashCount++
                continue
            }

            if ($line[$index] -eq '%' -and ($backslashCount % 2 -eq 0)) {
                $commentIndex = $index
                break
            }

            $backslashCount = 0
        }

        $line.Substring(0, $commentIndex)
    }

    return $strippedLines -join [Environment]::NewLine
}

$requiredFiles = @(
    'thesis.tex',
    'misc/iitthesis.cls',
    'misc/iitthesis-extra.sty',
    'misc/thesis-fields.tex',
    'misc/my-general.tex',
    'misc/my-thesis-specific.tex',
    'front/abstract.tex',
    'front/personal-acks.tex',
    'back/thesis.bib',
    '.latexmkrc'
)

$missing = $requiredFiles | Where-Object {
    -not (Test-Path -LiteralPath (Join-Path $overleafRoot $_))
}
if ($missing) {
    throw "Missing Technion template files: $($missing -join ', ')"
}

$latexmkrc = Get-Content -Raw (Join-Path $overleafRoot '.latexmkrc')
if ($latexmkrc -notmatch 'xelatex') {
    throw '.latexmkrc does not configure XeLaTeX.'
}

if ($latexmkrc -match '\$aux_dir\s*=|\$out_dir\s*=') {
    throw '.latexmkrc uses auxiliary/output directory settings incompatible with the local MiKTeX latexmk build.'
}

$entryPoint = Remove-TeXComments (Get-Content -Raw (Join-Path $overleafRoot 'thesis.tex'))
if ($entryPoint -notmatch '\\documentclass.*\{misc/iitthesis\}') {
    throw 'thesis.tex does not use misc/iitthesis.'
}

$includedFiles = @(
    '01_introduction',
    '02_background',
    '03_light_field_model',
    '04_aberration_and_scattering',
    '05_reconstruction_method',
    '06_experimental_setup_evaluation',
    '06_results',
    '07_discussion',
    '08_conclusion',
    'a_derivations',
    'b_additional_results'
)

foreach ($name in $includedFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $overleafRoot "main/$name.tex"))) {
        throw "Missing migrated source file: main/$name.tex"
    }

    $matches = [regex]::Matches($entryPoint, "\\include\{main/$([regex]::Escape($name))\}")
    if ($matches.Count -ne 1) {
        throw "Expected exactly one include for main/$name; found $($matches.Count)."
    }
}

$metadata = Remove-TeXComments (Get-Content -Raw (Join-Path $overleafRoot 'misc/thesis-fields.tex'))
if ($metadata -notmatch '\\addbibresource\{back/thesis\.bib\}') {
    throw 'misc/thesis-fields.tex does not register back/thesis.bib with biblatex.'
}

Write-Output 'Technion XeLaTeX template structure and migrated content are present.'
