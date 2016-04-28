# == Class: odoo::install
#
# Full description of class odoo here.

class odoo::config inherits odoo {
  file { $odoo::config_path :
    ensure => directory,
  } ~>
  file { "${odoo::config_path}/odoo.conf" :
    owner   => $odoo::odoo_user,
    group   => $odoo::odoo_group,
    mode    => '0640',
    content => template('odoo/odoo.conf.erb'),
    }
}