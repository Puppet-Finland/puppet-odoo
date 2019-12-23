# == Class: odoo::install
#
# Private class

class odoo::service inherits odoo {

  assert_private()
  
  case $::operatingsystem {
    'Debian': {

      file { '/etc/systemd/system/odoo.service' :
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('odoo/odoo.service.erb'),
      }

      exec { 'odoo-systemd-reload':
        command     => 'systemctl daemon-reload',
        path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
        refreshonly => true,
        require     => File['/etc/systemd/system/odoo.service'],
      }

      service { 'odoo' :
        ensure  => $odoo::service_status,
        require => Exec['odoo-systemd-reload'],
      }
    }

    default: {
      fail("${::operatingsystem} is not supported at this time")
      }
    }
  }
