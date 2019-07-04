param($PORT, $SRC_DIR) # cli args

if ($PORT -isnot [string]) {
    Write-Error "** You must use -PORT argument to give serial port **" -ErrorAction Stop
}

if ($SRC_DIR -isnot [string]) {
  Write-Error "** You must use -SRC_DIR argument to give source folder **" -ErrorAction Stop
}

Import-Module -Name ./psm1/util

Write-Host "##### START INSTALL #####" -ForegroundColor Green

$env:AMPY_PORT = $PORT # set ampy usb serial port as env
$env:AMPY_DELAY = 2 # fix "Could not enter raw repl"

$lib_src_dir = $SRC_DIR
$lib_dist_dir = '/lib'

Write-Host "-----[Install]-----" -ForegroundColor DarkBlue
# check has `lib` directory or create it
ampy_mk_dir $lib_dist_dir

# start put files
# get name of packages base on directory
[array]$packages= Get-ChildItem -Name -Directory -Path $lib_src_dir

foreach ($package in $packages) {

    $package_path = "$lib_src_dir/$package"
    $dist_path = "$lib_dist_dir/$package"

    Write-Host "Install $package" -ForegroundColor DarkCyan
    # check has package directory or create it
    ampy_mk_dir $dist_path

    # get  name of files base on directory
    [array]$files = Get-ChildItem -Name -Recurse -Path $package_path
    foreach ($file in $files) {
        ampy_put $package_path/$file $dist_path/$file
    }
}

# list files on board
Write-Host "-----[list files]-----" -ForegroundColor DarkBlue
ampy ls -r