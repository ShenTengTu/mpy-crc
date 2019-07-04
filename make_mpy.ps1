Import-Module -Name ./psm1/util -Function mk_dir, mk_mpy

$src_dir = 'src'
$dist_dir = 'dist'

mk_dir $dist_dir

 # get name of packages base on directory
 [array]$packages= Get-ChildItem -Name -Directory -Path $src_dir
 
 foreach ($package in $packages) {
  
  $package_path = "$src_dir/$package"
  $dist_path = "$dist_dir/$package"
  
  # check has package directory or create it
  mk_dir $dist_path

  # get  name of files base on directory
  [array]$files = Get-ChildItem -Name -Recurse -Path $package_path
  foreach ($file in $files) {
    $mpy = $file.replace(".py",".mpy")
    mk_mpy $package_path/$file $dist_path/$mpy
  }
}