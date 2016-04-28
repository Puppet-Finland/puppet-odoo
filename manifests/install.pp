# == Class: odoo::install
#
# Full description of class odoo here.

class odoo::install inherits odoo {
  include stdlib
  vcsrepo { $odoo::install_path:
    ensure   => present,
    provider => git,
    source   => $odoo::odoo_repo_url,
    revision => $odoo::branch,
    identity => $odoo::gitsshkey,
    user     => $odoo::odoo_repouser,
  }
  # install dependancy packages
  if $odoo::manage_packages {
    ensure_packages($odoo::dependency_packages)
  }
  wget::fetch { 'wkhtmltox':
    source      => 'http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb',
    destination => '/usr/local/src/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb',
    timeout     => 900,
  }
  package { 'wkhtmltox':
    source   => '/usr/local/src/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb',
    provider => 'dpkg',
    require  => Wget::Fetch['wkhtmltox'],
  }
  exec { 'odoo_pip_requirements_install':
    command => "/usr/bin/pip install -r ${odoo::install_path}/requirements.txt",
    require => Vcsrepo[$odoo::install_path],
    timeout => 900,
  }
}
