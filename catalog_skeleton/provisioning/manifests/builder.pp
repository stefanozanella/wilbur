$openwrt_source_url = "git://nbd.name/${::openwrt_release}.git"

$user = 'ops'
$user_home = "/home/${user}"

$buildroot_path = "${user_home}/${::openwrt_release}"

$openwrt_build_deps = [
  'subversion',
  'git-core',
  'libncurses5-dev',
  'gawk',
  'unzip',
  'gettext',
  'xsltproc',
  'bison',
  'libxml-parser-perl',
  'build-essential',
]

package { $openwrt_build_deps:
  ensure => installed,
  before => Exec['buildroot_init'],
}

user { $user:
  ensure => present,
  home   => $user_home,
  groups => $user,
}

exec { 'buildroot_init':
  command => "git clone ${openwrt_source_url} ${buildroot_path}",
  user    => $user,
  creates => $buildroot_path,
  require => User[$user],
  path    => ['/bin', '/usr/bin'],
}
