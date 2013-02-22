class apt {
  $apt_proxy_host = '192.168.122.1'
  $apt_proxy_port = '3128'

  Package {
    require => Exec['apt-get_update'] }

  package { 'lsb-release': ensure => installed }

  # TODO: Remove this conditional later on once
  # I have some time to write a better method
  case $::lsbdistcodename {
    lenny : {
      file { '/etc/apt/sources.list':
        source => 'puppet://puppet/apt/lenny-sources.list',
        notify => Exec['apt-get_update']
      }
    }
  }

  case $::lsbdistid {
    Ubuntu  : {
      file { '/etc/apt/sources.list':
        content => template('apt/Ubuntu_source.list.erb'),
        notify  => Exec['apt-get_update']
      }

      file { '/etc/apt/apt.conf.d/01proxy':
        content => template('apt/01proxy.erb'),
        notify  => Exec['apt-get_update']
      }
    }
    default : {
      fail("Module ${module_name} is not supported on ${::lsbdistid}")
    }
  }

  exec { 'apt-get_update':
    command     => 'apt-get update',
    refreshonly => true,
  }
}