class apt::unattended_upgrades {
  package { 'unattended-upgrades': ensure => installed }

  # Setup unattented-upgrades so uses both standard and security updates
  case $::lsbdistid {
    Ubuntu  : {
      file { '/etc/apt/apt.conf.d/50unattended-upgrades': content => template('apt/50unattended-upgrades.Ubuntu.erb') }
    }
    Debian  : {
      file { '/etc/apt/apt.conf.d/50unattended-upgrades': content => template('apt/50unattended-upgrades.Debian.erb') }
    }
    default : {
      fail("Module ${module_name} is not supported on ${::lsbdistid}")
    }
  }

  # Configure the periodic options like enabling automatic install of updates
  file { '/etc/apt/apt.conf.d/10periodic': content => template('apt/10periodic.erb') }

  # Sometimes workstations are off during the evening.
  # This will catch them and any mid-day upgrades.
  cron { 'noon-aptupdate-cron':
    command => '/etc/cron.daily/apt',
    user    => 'root',
    hour    => 12,
    minute  => 0,
    weekday => [Mon, Tue, Wed, Thu, Fri],
  }
}
