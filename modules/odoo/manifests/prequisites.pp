# == Class: odoo::prequisites
#
class odoo::prequisites inherits odoo::params {

  package { $::odoo::params::dependency_packages:
    ensure => installed,
  }
}
