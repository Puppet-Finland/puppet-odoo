# == Class: odoo::config
#
# Full description of class odoo here.

class odoo::config inherits odoo::params {

  file { "${::odoo::params::config_path}/odoo.conf":
    owner   => $odoo::params::odoo_user,
    group   => $odoo::params::odoo_group,
    mode    => '0640',
    content => template('odoo/odoo.conf.erb'),
  }

  file { $::odoo::params::script_path:
    ensure => directory,
    owner   => $odoo::params::odoo_user,
    group   => $odoo::params::odoo_group,
    mode    => '0640',
  }

  $scripts = $::odoo::params::scripts
  
  $scripts.each |$script| {
    file { "${::odoo::params::script_path}/${script}":
      owner   => $odoo::params::odoo_user,
      group   => $odoo::params::odoo_group,
      mode    => '0640',
      content => template("odoo/${script}.erb"),
      require => File[$::odoo::params::script_path],
    }
  }

  exec { "initialize_${$::odoo::params::db_name}":
    command     => "${::odoo::params::script_path}/initdb",
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    user        => $odoo::params::odoo_user,
    group       => $odoo::params::odoo_group, 
    refreshonly => true,
    unless      => "test -f ${::odoo::params::script_path}/.INITIALIZED", 
    require     => File["${::odoo::params::script_path}/initdb"],
  }

  file { "${odoo::params::install_path}/.INITIALIZED":
    ensure => directory,
    owner  => $odoo::params::odoo_user,
    group  => $odoo::params::odoo_group,
    mode   => '0640',
  }
      
  file { $odoo::params::data_dir:
    ensure => directory,
    owner  => $odoo::params::odoo_user,
    group  => $odoo::params::odoo_group,
    mode   => '0640',
  }

}
