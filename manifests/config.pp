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
    owner   => $odoo::params::odoo_user,
    group   => $odoo::params::odoo_group,
    mode    => '0640',
    content => template('odoo/odoo.conf.erb'),
  }
  
  $scripts = $::odoo::params::scripts
  
  $sripts.each |$script| {
    file { "${::odoo::params::script_path}/$script":
      owner   => $odoo::params::odoo_user,
      group   => $odoo::params::odoo_group,
      mode    => '0640',
      content => template("odoo/$script.erb"),
      require => $::odoo::params::script_path,
    }
  }
    
  file { $odoo::params::data_dir:
    ensure => directory,
    owner  => $odoo::params::odoo_user,
    group  => $odoo::params::odoo_group,
    mode   => '0640',
  }

}
