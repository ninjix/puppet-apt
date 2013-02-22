# Setup a PPA repo, where the name is "user/ppaname",
# e.g. "blueyed/ppa" ("ppa" being the default)
define apt::addppa ($apt_key = '', $dist = $::ppa_default_name, $ensure = present, $keyserver = 'keyserver.ubuntu.com') {
  $name_for_file = regsubst($name, '/', '-', 'G')
  $file = "/etc/apt/sources.list.d/${name_for_file}.list"

  file { $file: }

  case $ensure {
    present : {
      if ($dist) {
        File[$file] {
          content => "deb http://ppa.launchpad.net/${name}/ubuntu ${dist} main\n" }

        File[$file] {
          ensure => file }

        if ($apt_key) {
          apt::addkey { $apt_key: }
        }
      } else {
        File[$file] {
          ensure => false }
      }
    }
    absent  : {
      File[$file] {
        ensure => false }
    }
    default : {
      fail "Invalid 'ensure' value '${ensure}' for pparepo"
    }
  }
}