$ErrorActionPreference = 'Stop'

$requiredFiles = @(
    'thesis.tex',
    'misc/iitthesis.cls',
    'misc/iitthesis-extra.sty',
    'misc/thesis-fields.tex',
    '.latexmkrc'
)

$missing = $requiredFiles | Where-Object { -not (Test-Path $_) }
if ($missing) {
    throw "Missing Technion template files: $($missing -join ', ')"
}

$latexmkrc = Get-Content -Raw '.latexmkrc'
if ($latexmkrc -notmatch 'xelatex') {
    throw '.latexmkrc does not configure XeLaTeX.'
}

if ($latexmkrc -match '\$aux_dir\s*=|\$out_dir\s*=') {
    throw '.latexmkrc uses auxiliary/output directory settings incompatible with the local MiKTeX latexmk build.'
}

$entryPoint = Get-Content -Raw 'thesis.tex'
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
    if (-not (Test-Path "main/$name.tex")) {
        throw "Missing migrated source file: main/$name.tex"
    }

    $matches = [regex]::Matches($entryPoint, "\\include\{main/$([regex]::Escape($name))\}")
    if ($matches.Count -ne 1) {
        throw "Expected exactly one include for main/$name; found $($matches.Count)."
    }
}

$metadata = Get-Content -Raw 'misc/thesis-fields.tex'
if ($metadata -notmatch '\\addbibresource\{back/thesis\.bib\}') {
    throw 'misc/thesis-fields.tex does not register back/thesis.bib with biblatex.'
}

if (-not (Test-Path 'back/thesis.bib')) {
    throw 'Missing migrated bibliography: back/thesis.bib'
}

Write-Output 'Technion XeLaTeX template structure and migrated content are present.'
