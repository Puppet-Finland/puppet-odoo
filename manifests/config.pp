# == Class: odoo::config
#
# Full description of class odoo here.

class odoo::config inherits odoo::params {

  file { "$odoo::config_path/odoo.conf":
    owner   => $odoo::params::odoo_user,
    group   => $odoo::params::odoo_group,
    mode    => '0640',
    content => template('odoo/odoo.conf.erb'),
  }

  file { "$data_dir":
    ensure => directory,
    owner  => $odoo::params::odoo_user,
    group  => $odoo::params::odoo_group,
    mode   => '0640',
  }

}
