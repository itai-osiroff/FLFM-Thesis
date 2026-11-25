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

$mainChapters = [ordered]@{
    '01_introduction' = 'Introduction'
    '02_literature_review' = 'Literature Review'
    '03_light_field_microscope' = 'What is a light-field microscope'
    '04_our_setup' = 'Our setup'
    '05_image_reconstruction' = 'Image reconstruction'
    '06_results' = 'Results'
    '07_discussion_and_conclusions' = 'Discussion and Conclusions'
}
$appendices = @('a_reconstruction_method', 'b_derivations', 'c_additional_results')
$appendixBoundaries = [regex]::Matches($entryPoint, '\\appendix\b')
if ($appendixBoundaries.Count -ne 1) {
    throw 'Expected exactly one appendix boundary after the seven main chapters.'
}
$boundary = $appendixBoundaries[0]
$mainText = $entryPoint.Substring(0, $boundary.Index)
$appendixText = $entryPoint.Substring($boundary.Index + $boundary.Length)

function Assert-IncludeOrder {
    param([string]$Text, [string[]]$Expected, [string]$Area)

    $inputs = [regex]::Matches($Text, '\\(include|input)\{([^}]+)\}') |
        Where-Object { $_.Groups[2].Value -notmatch '^(misc|front)/' }
    $inputs = @($inputs)
    $actual = @($inputs | ForEach-Object { $_.Groups[2].Value })
    $wanted = @($Expected | ForEach-Object { "main/$_" })
    if (($actual -join '|') -cne ($wanted -join '|') -or
        @($inputs | Where-Object { $_.Groups[1].Value -cne 'include' }).Count) {
        throw "Unexpected $Area includes or order. Expected: $($wanted -join ', '); found: $($actual -join ', ')."
    }
    if ($Text -match '\\chapter\*?(?:\[[^\]]*\])?\{') {
        throw "Chapter headings in $Area must be owned by the included sources."
    }
}

Assert-IncludeOrder $mainText @($mainChapters.Keys) 'main matter'
Assert-IncludeOrder $appendixText $appendices 'appendix matter'

$numberedSources = @(Get-ChildItem -LiteralPath (Join-Path $overleafRoot 'main') -File |
    Where-Object { $_.Name -match '^\d{2}_.*\.tex$' } |
    ForEach-Object { $_.BaseName } | Sort-Object)
if (($numberedSources -join '|') -cne (@($mainChapters.Keys) -join '|')) {
    throw 'The main directory must contain exactly the seven current numbered chapter sources; remove legacy duplicates.'
}

function Get-ChapterSourceText {
    param([string]$RelativePath, [string[]]$Ancestors = @())

    $sourcePath = [IO.Path]::GetFullPath((Join-Path $overleafRoot $RelativePath))
    if ($Ancestors -contains $sourcePath) {
        throw "Cyclic chapter input: $RelativePath"
    }
    if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
        throw "Missing chapter input: $RelativePath"
    }
    $source = Remove-TeXComments (Get-Content -Raw -LiteralPath $sourcePath)
    if ($source -match '\\appendix\b') {
        throw "Appendix boundary must appear only in thesis.tex, not $RelativePath."
    }
    $combined = $source
    # Follow literal TeX inputs, including the legitimate editable figure source,
    # so a chapter or appendix boundary cannot hide in an included fragment.
    foreach ($inputMatch in [regex]::Matches($source, '\\(?:include|input)\{([^}]+)\}')) {
        $inputPath = $inputMatch.Groups[1].Value
        if (-not [IO.Path]::GetExtension($inputPath)) { $inputPath += '.tex' }
        $combined += [Environment]::NewLine +
            (Get-ChapterSourceText $inputPath ($Ancestors + @($sourcePath)))
    }
    return $combined
}

foreach ($name in @($mainChapters.Keys) + $appendices) {
    $sourcePath = Join-Path $overleafRoot "main/$name.tex"
    if (-not (Test-Path -LiteralPath $sourcePath)) {
        throw "Missing migrated source file: main/$name.tex"
    }
    $source = Get-ChapterSourceText "main/$name.tex"
    $headings = [regex]::Matches($source, '\\chapter(\*)?(?:\[[^\]]*\])?\{([^}]+)\}')
    if ($headings.Count -ne 1 -or $headings[0].Groups[1].Success) {
        throw "Expected one numbered chapter heading in main/$name.tex."
    }
    if ($mainChapters.Contains($name) -and $headings[0].Groups[2].Value -cne $mainChapters[$name]) {
        throw "Unexpected chapter title in main/$name.tex; expected '$($mainChapters[$name])'."
    }
}

$metadata = Remove-TeXComments (Get-Content -Raw (Join-Path $overleafRoot 'misc/thesis-fields.tex'))
if ($metadata -notmatch '\\addbibresource\{back/thesis\.bib\}') {
    throw 'misc/thesis-fields.tex does not register back/thesis.bib with biblatex.'
}

Write-Output 'Technion XeLaTeX template, seven ordered main chapters, and appendix boundaries are valid.'
