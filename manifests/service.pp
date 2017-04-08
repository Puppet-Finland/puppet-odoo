# == Class: odoo::install
#
# Full description of class odoo here.

class odoo::service inherits odoo {

  case $::operatingsystem {
    'Debian': {

      file { '/etc/systemd/system/odoo.service' :
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
        content   => template('odoo/odoo.service.erb'),
        subscribe => Service['odoo'],
      }
      
      service { 'odoo' :
        ensure  => $odoo::service_status,
        require => File['/etc/systemd/system/odoo.service'],
      }
    }

    default: {
      fail("${::operatingsystem} is not supported at this time")
      }
    }
  }
