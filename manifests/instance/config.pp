define collectd::instance::config (
  $interval = '30',
  $pidfile = '/var/run/collectd',
  $additional_config = []
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  # Create service script in /etc/init.d
  file { "/etc/init.d/collectd${instance}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('collectd/init/collectd.erb')
  }

  # Create /etc/collectd${instance}.conf
  file { "collectd${instance}.conf":
    ensure  => file,
    path    => "/etc/collectd${instance}.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('collectd/conf/collectd.erb'),
  }

  file { "/etc/collectd${instance}.d":
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { "collectd${instance}/types.db":
    ensure  => file,
    path    => "/etc/collectd${instance}.d/types.db",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/types.db"
  }

}
