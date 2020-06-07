#
# == Class: odoo::config
#
class odoo::config {

  assert_private()
  
  file { "${::odoo::config_path}/odoo.conf":
    owner   => 'root',
    group   => $odoo::odoo_group,
    mode    => '0640',
    content => template('odoo/odoo.conf.erb'),
  }

  file { $::odoo::script_path:
    ensure => directory,
    owner  => $odoo::odoo_user,
    group  => $odoo::odoo_group,
    mode   => '0600',
  }

  file { $::odoo::pidpath:
    ensure => directory,
    owner  => $odoo::odoo_user,
    group  => $odoo::odoo_group,
    mode   => '0600',
  }

  $scripts = $::odoo::scripts

  $scripts.each |$script| {
    file { "${::odoo::script_path}/${script}":
      owner   => $odoo::odoo_user,
      group   => $odoo::odoo_group,
      mode    => '0700',
      content => template("odoo/${script}.erb"),
      require => File[$::odoo::script_path],
    }
  }

  exec { "initialize_db_${$::odoo::db_name}":
    command => "${::odoo::script_path}/initdb",
    path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
    user    => 'root',
    group   => $odoo::odoo_group,
    unless  => "${::odoo::script_path}/testdb",
    require => File["${::odoo::script_path}/testdb"],
  }

  file { $::odoo::data_dir:
    ensure => directory,
    owner  => $::odoo::odoo_user,
    group  => $::odoo::odoo_group,
    mode   => '0600',
  }

  file { $::odoo::logdir:
    ensure => directory,
    owner  => $::odoo::odoo_user,
    group  => $::odoo::odoo_group,
    mode   => '0600',
  }
}
