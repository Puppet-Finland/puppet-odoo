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
  
  $scripts.each |$item| {
    file { "${::odoo::params::script_path}/${item}":
      owner   => $odoo::params::odoo_user,
      group   => $odoo::params::odoo_group,
      mode    => '0640',
      content => template("odoo/${item}.erb"),
      require => File[$::odoo::params::script_path],
    }
  }

  file { $odoo::params::data_dir:
    ensure => directory,
    owner  => $odoo::params::odoo_user,
    group  => $odoo::params::odoo_group,
    mode   => '0640',
  }

}
