param(
    [string]$Validator = (Join-Path $PSScriptRoot '../verify-template.ps1'),
    [string]$FixtureRoot = (Join-Path $PSScriptRoot '../../work/seven-chapter-migration/validator-fixtures')
)

$ErrorActionPreference = 'Stop'
$null = New-Item -ItemType Directory -Force -Path $FixtureRoot
$chapters = [ordered]@{
    '01_introduction' = 'Introduction'
    '02_literature_review' = 'Literature Review'
    '03_light_field_microscope' = 'What is a light-field microscope'
    '04_our_setup' = 'Our setup'
    '05_image_reconstruction' = 'Image reconstruction'
    '06_results' = 'Results'
    '07_discussion_and_conclusions' = 'Discussion and Conclusions'
}
$legacy = [ordered]@{
    '01_introduction' = 'Introduction'
    '02_background' = 'Background'
    '03_light_field_model' = 'Light Field Microscopy Model'
    '04_aberration_and_scattering' = 'Aberration and Scattering Through Biological Tissue'
    '05_reconstruction_method' = 'Reconstruction Method'
    '06_experimental_setup_evaluation' = 'Experimental Setup, Data, and Evaluation Protocol'
    '07_results' = 'Results'
    '08_discussion' = 'Discussion'
    '09_conclusion' = 'Conclusion'
}

function New-Fixture {
    param([string]$Name, [System.Collections.IDictionary]$MainChapters = $chapters)
    # Each run gets a fresh directory; never delete a shared or computed tree.
    $root = Join-Path $FixtureRoot ($Name + '-' + [guid]::NewGuid().ToString('N'))
    foreach ($dir in @('misc', 'front', 'back', 'main')) {
        $null = New-Item -ItemType Directory -Force -Path (Join-Path $root $dir)
    }
    foreach ($file in @('misc/iitthesis.cls', 'misc/iitthesis-extra.sty',
        'misc/my-general.tex', 'misc/my-thesis-specific.tex', 'front/abstract.tex',
        'front/personal-acks.tex', 'back/thesis.bib')) {
        Set-Content -LiteralPath (Join-Path $root $file) -Value '' -Encoding UTF8
    }
    Set-Content -LiteralPath (Join-Path $root '.latexmkrc') -Value 'xelatex' -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $root 'misc/thesis-fields.tex') -Value '\addbibresource{back/thesis.bib}' -Encoding UTF8
    $body = @('\documentclass[MSc]{misc/iitthesis}', '\begin{document}')
    foreach ($name in $MainChapters.Keys) {
        $body += "\include{main/$name}"
        Set-Content -LiteralPath (Join-Path $root "main/$name.tex") -Value "\chapter{$($MainChapters[$name])}" -Encoding UTF8
    }
    $body += '\appendix', '\include{main/a_reconstruction_method}', '\include{main/b_derivations}', '\include{main/c_additional_results}', '\end{document}'
    Set-Content -LiteralPath (Join-Path $root 'main/a_reconstruction_method.tex') -Value '\chapter{Reconstruction method in detail}' -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $root 'main/b_derivations.tex') -Value '\chapter{Additional Derivations}' -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $root 'main/c_additional_results.tex') -Value '\chapter{Additional Results}' -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $root 'thesis.tex') -Value $body -Encoding UTF8
    return $root
}

function Replace-InFixture {
    param([string]$Root, [string]$File, [string]$Old, [string]$New)
    $path = Join-Path $Root $File
    $text = Get-Content -Raw -LiteralPath $path
    if (-not $text.Contains($Old)) { throw "Fixture replacement not found: $Old" }
    Set-Content -LiteralPath $path -Value $text.Replace($Old, $New) -Encoding UTF8
}

$cases = @()
$cases += @{ Name = 'seven ordered chapters'; Root = (New-Fixture 'valid'); Accept = $true }
$cases += @{ Name = 'old nine-chapter structure'; Root = (New-Fixture 'legacy' $legacy); Accept = $false }
$root = New-Fixture 'swapped'
Replace-InFixture $root 'thesis.tex' "\include{main/01_introduction}`r`n\include{main/02_literature_review}" "\include{main/02_literature_review}`r`n\include{main/01_introduction}"
$cases += @{ Name = 'swapped chapters'; Root = $root; Accept = $false }
$root = New-Fixture 'extra'
Replace-InFixture $root 'thesis.tex' '\appendix' "\include{main/extra}`n\appendix"
Set-Content -LiteralPath (Join-Path $root 'main/extra.tex') -Value '\chapter{Extra}' -Encoding UTF8
$cases += @{ Name = 'extra main chapter'; Root = $root; Accept = $false }
$root = New-Fixture 'boundary'
Replace-InFixture $root 'thesis.tex' '\include{main/07_discussion_and_conclusions}' "\appendix`n\include{main/07_discussion_and_conclusions}"
Replace-InFixture $root 'thesis.tex' "\appendix`r`n\include{main/a_reconstruction_method}" '\include{main/a_reconstruction_method}'
$cases += @{ Name = 'main chapter after appendix boundary'; Root = $root; Accept = $false }
$root = New-Fixture 'nested'
Add-Content -LiteralPath (Join-Path $root 'main/03_light_field_microscope.tex') -Value '\chapter{Unmerged degradation}' -Encoding UTF8
$cases += @{ Name = 'second chapter inside a chapter source'; Root = $root; Accept = $false }
$root = New-Fixture 'wrong-title'
Replace-InFixture $root 'main/04_our_setup.tex' 'Our setup' 'Experimental Setup, Data, and Evaluation Protocol'
$cases += @{ Name = 'obsolete chapter title'; Root = $root; Accept = $false }
$root = New-Fixture 'duplicate'
Replace-InFixture $root 'thesis.tex' '\appendix' "\include{main/01_introduction}`n\appendix"
$cases += @{ Name = 'duplicate include'; Root = $root; Accept = $false }
$root = New-Fixture 'input'
Replace-InFixture $root 'thesis.tex' '\appendix' "\input{main/extra}`n\appendix"
Set-Content -LiteralPath (Join-Path $root 'main/extra.tex') -Value '\chapter{Extra}' -Encoding UTF8
$cases += @{ Name = 'extra main input'; Root = $root; Accept = $false }
$root = New-Fixture 'leftover'
Set-Content -LiteralPath (Join-Path $root 'main/08_discussion.tex') -Value '\chapter{Discussion}' -Encoding UTF8
$cases += @{ Name = 'leftover numbered legacy source'; Root = $root; Accept = $false }
$root = New-Fixture 'comments'
Add-Content -LiteralPath (Join-Path $root 'thesis.tex') -Value '% \include{main/08_discussion}' -Encoding UTF8
Add-Content -LiteralPath (Join-Path $root 'main/03_light_field_microscope.tex') -Value '% \chapter{Historical comment}' -Encoding UTF8
$cases += @{ Name = 'commented legacy structure'; Root = $root; Accept = $true }
$root = New-Fixture 'nested-main'
Add-Content -LiteralPath (Join-Path $root 'main/03_light_field_microscope.tex') -Value '\input{main/06_results}' -Encoding UTF8
$cases += @{ Name = 'main chapter hidden in nested input'; Root = $root; Accept = $false }
$root = New-Fixture 'nested-boundary'
Set-Content -LiteralPath (Join-Path $root 'main/boundary.tex') -Value '\appendix' -Encoding UTF8
Add-Content -LiteralPath (Join-Path $root 'main/03_light_field_microscope.tex') -Value '\input{main/boundary}' -Encoding UTF8
$cases += @{ Name = 'appendix boundary hidden in nested input'; Root = $root; Accept = $false }
$root = New-Fixture 'figure-input'
$null = New-Item -ItemType Directory -Path (Join-Path $root 'figures')
Set-Content -LiteralPath (Join-Path $root 'figures/diagram.tex') -Value 'Original conceptual figure.' -Encoding UTF8
Add-Content -LiteralPath (Join-Path $root 'main/05_image_reconstruction.tex') -Value '\input{figures/diagram}' -Encoding UTF8
$cases += @{ Name = 'legitimate figure input'; Root = $root; Accept = $true }
$root = New-Fixture 'input-cycle'
Set-Content -LiteralPath (Join-Path $root 'main/cycle.tex') -Value '\input{main/cycle}' -Encoding UTF8
Add-Content -LiteralPath (Join-Path $root 'main/03_light_field_microscope.tex') -Value '\input{main/cycle}' -Encoding UTF8
$cases += @{ Name = 'cyclic nested input'; Root = $root; Accept = $false }

$failures = @()
foreach ($case in $cases) {
    $accepted = $true
    $reason = ''
    try { & $Validator -OverleafDir $case.Root | Out-Null }
    catch { $accepted = $false; $reason = $_.Exception.Message }
    if ($accepted -ne $case.Accept) {
        $failures += $case.Name
        Write-Output "FAIL: $($case.Name) (accepted=$accepted; $reason)"
    } else { Write-Output "PASS: $($case.Name)" }
}
if ($failures.Count) { throw "$($failures.Count)/$($cases.Count) structural cases failed: $($failures -join ', ')" }
Write-Output "$($cases.Count)/$($cases.Count) structural cases passed."
