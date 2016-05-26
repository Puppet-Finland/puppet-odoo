# == Class: odoo::install
#
# Full description of class odoo here.

class odoo::service inherits odoo {
  case $::operatingsystem {
    'Ubuntu': {
      file { '/etc/init/odoo.conf' :
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('odoo/upstart.conf.erb'),
        notify  => Service['odoo'],
        }
      service { 'odoo' :
        ensure  => $odoo::service_status,
        require => File['/etc/init/odoo.conf'],
        }
      }
    default: {
      fail("${::operatingsystem} is not supported")
      }
    }
  }