# == Class: odoo::install
#
class odoo::install {

  assert_private()

  package { 'python3-pip':
    ensure => 'present',
  }

  group { $::odoo::odoo_group:
    ensure      => present,
  }

  file { $::odoo::home_path:
    ensure => directory,
  }

  file { "${::odoo::home_path}/${::odoo::odoo_user}":
    ensure  => directory,
    require => File[$::odoo::home_path],
  }

  user { $::odoo::odoo_user:
    ensure  => present,
    home    => "${::odoo::home_path}/${::odoo::odoo_user}",
    require => [
      Group[$::odoo::odoo_group],
      File["${::odoo::home_path}/${::odoo::odoo_user}"],
    ]
  }

  file { "${::odoo::home_path}/${::odoo::odoo_user}/.pgpass":
    ensure  => present,
    owner   => $::odoo::odoo_user,
    group   => $::odoo::odoo_group,
    mode    => '0600',
    content => template('odoo/pgpass.erb'),
    require => User[$::odoo::odoo_user],
  }

  file { $::odoo::install_path:
    ensure  => directory,
    owner   => $::odoo::odoo_user,
    mode    => '0764',
    require => User[$::odoo::odoo_user]
  }

  vcsrepo { $::odoo::install_path:
    ensure   => present,
    provider => git,
    source   => $::odoo::odoo_repo_url,
    revision => $::odoo::branch,
    depth    => '1',
    require  => File[$::odoo::install_path],
    }

  ensure_packages($odoo::dependency_packages)

/*
    $_packages = [ 'fonts-dejavu-core', 'ttf-bitstream-vera', 'fonts-liberation', 'fonts-freefont' ]

    package { $_packages:
      ensure => 'installed',
    }

    package { 'fontconfig-config':
      ensure => 'installed',
      require => Package[$_packages],
    }

    package { $::odoo::fontconfig_dependency_packages:
      ensure => 'installed',
      require => Package['fontconfig-config'],
    }

    package { $::odoo::wkhtmltox_dependency_packages:
      ensure => 'installed',
      require => Package[$::odoo::fontconfig_dependency_packages],
    }

    wget::fetch { 'wkhtmltox':
    source      => $::odoo::wkhtmltox_source,
    destination => '/tmp/wkhtmltox.deb',
    unless      => 'test -f /tmp/wkhtmltox.deb',
    timeout     => 900,
  }
*/

#  package { 'wkhtmltox':
#    source   => '/tmp/wkhtmltox.deb',
#    provider => 'dpkg',
#    require  => [
#      Package[$odoo::wkhtmltox_dependency_packages],
#      Wget::Fetch['wkhtmltox'],
#    ],
#  }

  exec { 'odoo_pip3_requirements_install':
    command => "/usr/bin/pip3 install -r ${::odoo::install_path}/requirements.txt",
    require => Vcsrepo[$odoo::install_path],
    timeout => 900,
  }
}
