$openwrt_release = 'attitude_adjustment'

$openwrt_source_url = "git://nbd.name/${openwrt_release}.git"

$openwrt_build_deps = [
  'subversion',
  'git-core',
  'libncurses5-dev',
  'gawk',
  'unzip',
  'gettext',
  'xsltproc',
  'libxml-parser-perl',
  'build-essential',
]

$buildroot_path = "/home/ops/${openwrt_release}"

package { $openwrt_build_deps:
  ensure => installed,
  before => Exec['checkout buildroot'],
}

user { 'ops':
  ensure => present,
  home   => '/home/ops',
  groups => 'ops',
}

exec { 'checkout buildroot':
  command => "git clone ${openwrt_source_url} ${buildroot_path}",
  user    => 'ops',
  creates => $buildroot_path,
  require => User['ops'],
  path    => ['/bin', '/usr/bin'],
}
