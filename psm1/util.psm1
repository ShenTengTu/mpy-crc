<#
    .SYNOPSIS
    Create directory if not exist.
    .PARAMETER dir
    A directory Path .
#>
function mk_dir([string]$dir) {
    if (-not (Test-Path -PathType Container -Path $dir)) {
        New-Item -ItemType directory -Path $dir
    }
}

<#
    .SYNOPSIS
    Create file if not exist.
    .PARAMETER file
    A file Path .
#>
function mk_file([string]$file) {
    if (-not (Test-Path -PathType Leaf -Path $file)) {
        New-Item -ItemType File -Path $file
    }
}

<#
    .SYNOPSIS
    Compile python script to `.mpy` file.
    .PARAMETER source
    A source python file path .
    .PARAMETER dist
    A output mpy file path .
#>
function mk_mpy ([string]$source, [string]$dist) {
    if (Test-Path -Path $source) {
        mpy-cross -o $dist $source
        Write-Output "$source --> $dist"
    } else {
        Write-Host "** file no exist: $source **" -ForegroundColor DarkYellow
    }
}

<#
    .SYNOPSIS
    Copy file to destination.
    .PARAMETER source
    A source file path .
    .PARAMETER dist
    A destination file path .
#>
function copy_file ([string]$source, [string]$dist) {
    if (Test-Path -Path $source) {
        Copy-Item $source -Destination $dist
        Write-Output "$source --> $dist"
    } else {
        Write-Host "** file no exist: $source **" -ForegroundColor DarkYellow
    }
}

<#
    .SYNOPSIS
    Check board has the directory or not
    .PARAMETER dir
    A directory Path on board.
#>
function ampy_has_dir ([string]$dir) {
    $flag = $false
    [array]$paths = ampy ls -r
    foreach($p in $paths) {
      if ($p -match "^$dir") {
        $flag = $true
        break
      }
    }
    return $flag
}

<#
    .SYNOPSIS
    Create directory if not exist on board.
    .PARAMETER dir
    A directory Path on board.
#>
function ampy_mk_dir([string]$dir) {
  $flag = ampy_has_dir $dir
  if($flag -eq $false) {
    Write-Output "** Create folder ($dir) on board **"
    ampy mkdir $dir
  } else {
    Write-Output "($dir) is exists in board."
  }
}

<#
    .SYNOPSIS
    Copy files from PC into board
    .PARAMETER source
    A source file path on PC.
    .PARAMETER dist
    A file path on board.
#>
function ampy_put ([string]$source, [string]$dist) {
    if (Test-Path -Path $source) {
        ampy put $source $dist
        Write-Output "$source --> $dist"
    } else {
        Write-Host "** file no exist: $source **" -ForegroundColor DarkYellow
    }
}

Export-ModuleMember -Function mk_dir, mk_file, mk_mpy, copy_file, ampy_has_dir, ampy_mk_dir, ampy_put