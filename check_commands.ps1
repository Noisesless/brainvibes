$templatesContent = Get-Content "C:\xampp\htdocs\brainvibes\gemini-templates.md" -Raw
$sections = [regex]::Matches($templatesContent, "### \d+[A-Z]\. Saklar: `([^`]+)`")
$count = $sections.Count
Write-Output ("Found " + $count + " macro commands")
foreach ($match in $sections) {
    $cmdName = $match.Groups[1].Value
    Write-Output ("  - " + $cmdName)
}
