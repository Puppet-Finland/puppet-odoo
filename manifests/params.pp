# == Class: odoo::params
#
# Full description of class odoo here.

class odoo::params {
  $odoo_repo_url     = 'https://github.com/odoo/odoo.git'
  $branch            = '10'
  $config_path       = '/etc'
  $install_path      = '/opt/odoo'
  $service_status    = 'running'
  $odoo_user         = 'odoo'
  $odoo_group        = 'odoo'
  $odoo_repouser     = 'pelamm'
  $git_sshkey        = 'XD6fFaGTmqGc2rycTUAAIAOF7UM/DNyrP5CDlpmiTpttSGt
  Llf/ipqn7qIduBXMP/2U32L85918n2usrrJjf+sCgYBalb4KGj6/UwC1H3fy72o7
  1vNqWwjNKdw/0w6ekq38bE7nXsf1d3o7LXJhTbz9kGdhF5VLXZjmaXrsWvKn7FxQ
  5Rqlsr2X3DVJ0Obc5HZyzrfZLbboYt8xLXihp2fqr0UJ8jaCXnjrOl0QBUPyXyp3
  6dTjDD5+5bw5rAUXHlCZwQKBgFDbykcKrNRfwH1z1ugauRHswP9mctvvsPq6bD+K
  /Mh3XwUzcuKdvXT5li0Z4z9lxy7byo/xaaNsOU3ngn++8dRSxKZhNGQNb+5Pmfcf
  7IpFnD9IlndGpsh9It2AJdvkWAax06Lsr5VWkCHyt3TahI0jAGSj3avon9/HSW95
  SWJVAoGBAKuYXsJGw0QvZFhnUnFKHeAqs4v4lyY1UW7RJT9z3sJBgTHxljfb0J95
  nXb9zlhpObPybPRHr8v8TlgBybL8Aoy7w+g7ZpXZOk/37MVqffBGl7qOlaQIYvjF
  Nze0KqCJrWNNm2A/vfjAQhkMjhB7rmlkLGVOJRCWwOZCf/NTS/gn
  -----END RSA PRIVATE KEY-----~'

  $manage_packages   = true 

  $adminpass         = 'admin'
  $db_host           = '127.0.0.1'
  $db_port           =  5432
  $db_user           = 'odoo'
  $db_password       = 'odoo'
  $db_name           = 'odoo'
  $db_filter         = '/^odoo$/'

  # email options
  $email_from        = 'hostmaster@tietoteem.fi'
  $smtp_server       = 'zcs.tietoteema.fi'
  $smtp_port         = 25
  $smtp_ssl          = false
  $smtp_user         = 'petri.lammi@tietoteema.fi'
  $smtp_password     = 'password'

  $addons_path       = '/opt/odoo/addons'
  $log_level         = 'debug'
  $logdir            = '/var/log/odoo'
  $logfile           = '/var/log/odoo/server.log'
  $logrotate         = 0

  $data_dir          = '/mnt/addons'
  $proxy_mode        = false

  $workers           = 0
  $limit_request     = 8196
  $limit_memory_soft = 671088640 # ~640MB
  $limit_memory_hard = 805306368 # ~768MB
  $limit_time_cpu    = 60
  $limit_time_real   = 120
  $max_cron_threads  = 2

  case $::operatingsystem {
    'Debian': {
      $dependency_packages =
      [
        'ca-certificates',
        'curl',
        'node-less',
        'python-gevent',
        'python-pip',
        'python-renderpm',
        'python-support',
        'python-watchdog',
        'rubygems',
        'python-dev',
        'python-pip',
        'libxml2-dev','libxslt1-dev',
        'libevent-dev','libsasl2-dev',
        'postgresql-server-dev-all',
        'libldap2-dev',
        'xfonts-base',
        'xfonts-75dpi',
        'xfonts-utils',
        'libfontenc1',
        'libxfont1',
        'xfonts-encodings',
        'fontconfig',
        'libjpeg62-turbo',
        'libfontconfig1',
        'libjpeg-dev',
        'libz-dev'
      ]

      $wkhtmltox_source = 'http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb'
      $psycogreen_version = '1.0'
      $odoo_version = '10.0'
      $odoo_release = '20170207'
      
    }

    default: {
      fail("${::operatingsystem} is not yet supported")
    }
  }
  
}
