# == Class: odoo::params
#
# Full description of class odoo here.

class odoo::params {
  $odoo_repo_url     = 'https://github.com/odoo/odoo.git'
  $branch            = '8.0'
  $config_path       = '/etc'
  $install_path      = '/opt/odoo'
  $service_status    = 'running'
  $odoo_user         = 'demoer'
  $odoo_group        = 'demoer'
  $odoo_repouser     = undef
  $git_sshkey        = undef

  $adminpass         = 'admin'
  $db_host           = '127.0.0.1'
  $db_port           = '5432'
  $db_user           = 'demoer'
  $db_password       = 'demoer'
  $db_filter         = 'demoer'

  # email options
  $email_from        = undef
  $smtp_server       = undef
  $smtp_port         = undef
  $smtp_ssl          = undef
  $smtp_user         = undef
  $smtp_password     = undef

  $addons_path       = undef
  $log_level         = undef
  $logfile           = undef
  $logrotate         = 0

  $data_dir          = undef
  $proxy_mode        = undef

  $workers           = 0
  $limit_request     = 8196
  $limit_memory_soft = 671088640 # ~640MB
  $limit_memory_hard = 805306368 # ~768MB
  $limit_time_cpu    = 60
  $limit_time_real   = 120
  $max_cron_threads  = 2

  case $::operatingsystem {
    'Ubuntu': {
      $dependency_packages = ['python-dev','python-pip','libxml2-dev','libxslt1-dev','libevent-dev','libsasl2-dev','postgresql-server-dev-all','libldap2-dev','xfonts-base','xfonts-75dpi','xfonts-utils','libfontenc1','libxfont1','xfonts-encodings','fontconfig','libfontconfig1','libjpeg-dev', 'libjpeg-turbo8', 'libxrender1']
    }
    default: {
      fail("${::operatingsystem} is not yet supported")
    }
  }
  $manage_packages = true
}
