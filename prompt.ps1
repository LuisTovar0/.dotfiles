# Configuration Constants (using Truecolor only)

$esc               = [char]27
$fgTextRgb         = "38;2;248;248;242"

# Truecolor backgrounds by section
$bgAdminRgb        = "48;2;255;184;108"   # Admin segment
$bgPathRgb         = "48;2;98;114;164"    # Path segment
$bgGitRgb          = "48;2;255;121;198"   # Git segment

# Symbols
$symbolFolder      = [char]0xF07B          # 
$symbolShield      = [char]0xF132          # 
$symbolLeftCircle  = [char]0xe0b6          # 
$symbolTriangle    = [char]0xe0b0          # 
$symbolGitIcon     = [char]0xe0a0          # 

function Get-CurrentGitBranch {
    try { (git rev-parse --abbrev-ref HEAD 2>$null).Trim() } catch { '' }
}

# Segment Functions (return Text and BgColor)

function Get-GitSegment {
    param([PSCustomObject]$NextSegment)
    $branch = Get-CurrentGitBranch
    if (-not $branch) { return $NextSegment }

    $ownBg  = $bgGitRgb
    $nextBg = $NextSegment.BgColor
    $sepFg  = $ownBg -replace '^48','38'

    $body      = "${esc}[${fgTextRgb};${ownBg}m $symbolGitIcon $branch "
    $separator = "${esc}[${sepFg};${nextBg}m$symbolTriangle"
    $text      = "$body$separator$($NextSegment.Text)"
    return [PSCustomObject]@{ Text = $text; BgColor = $ownBg }
}

function Get-PathSegment {
    param([PSCustomObject]$NextSegment)
    $parts  = (Get-Location).Path -split '\\'
    $folder = if ($parts.Length -ge 2) { "$($parts[-2])\\$($parts[-1])" } else { (Get-Location).Path }

    $ownBg  = $bgPathRgb
    $nextBg = $NextSegment.BgColor
    $sepFg  = $ownBg -replace '^48','38'

    # prepend folder icon
    $body      = "${esc}[${fgTextRgb};${ownBg}m $symbolFolder  $folder "
    $separator = "${esc}[${sepFg};${nextBg}m$symbolTriangle"
    $text      = "$body$separator$($NextSegment.Text)"
    return [PSCustomObject]@{ Text = $text; BgColor = $ownBg }
}

function Get-AdminSegment {
    param([PSCustomObject]$NextSegment)
    $isAdmin = (New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    $nextBg = $NextSegment.BgColor
    if ($isAdmin) {
        $ownBg      = $bgAdminRgb
        $leftFg     = $ownBg -replace '^48','38'
        $leftCircle = "${esc}[${leftFg}m$symbolLeftCircle"
        # use shield icon
        $adminText  = "${esc}[${fgTextRgb};${ownBg}m $symbolShield  Admin mode "
        $sepFg      = $leftFg
        $separator  = "${esc}[${sepFg};${nextBg}m$symbolTriangle"

        $text = "$leftCircle$adminText$separator$($NextSegment.Text)"
        return [PSCustomObject]@{ Text = $text; BgColor = $ownBg }
    } else {
        $ownBg      = $nextBg
        $leftFg     = $ownBg -replace '^48','38'
        $leftCircle = "${esc}[${leftFg}m$symbolLeftCircle"
        $text       = "$leftCircle$($NextSegment.Text)"
        return [PSCustomObject]@{ Text = $text; BgColor = $ownBg }
    }
}

# prompt: chain segments via PSCustomObjects (no arrow)
function prompt {
    # Final reset segment (no arrow) uses default bg (49)
    $resetSegment = [PSCustomObject]@{ Text = "${esc}[0m"; BgColor = "49" }

    # Git segment (if any)
    $segment = if (Get-CurrentGitBranch) { Get-GitSegment -NextSegment $resetSegment } else { $resetSegment }

    # Path segment
    $segment = Get-PathSegment -NextSegment $segment

    # Admin segment
    $segment = Get-AdminSegment -NextSegment $segment

    return "$($segment.Text) "
}
