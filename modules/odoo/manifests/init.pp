# == Class: odoo
#
# Full description of class odoo here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'odoo':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class odoo (

  # install options
  $odoo_repo_url        = $odoo::params::odoo_repo_url,
  $branch               = $odoo::params::branch,
  $config_path          = $odoo::params::config_path,
  $install_path         = $odoo::params::install_path,
  $service_status       = $odoo::params::service_status,
  $odoo_user            = $odoo::params::odoo_user,
  $odoo_group           = $odoo::params::odoo_group,
  $odoo_repouser        = $odoo::params::odoo_repouser,
  $gitsshkey            = $odoo::params::gitsshkey,

  # database options
  $adminpass            = $odoo::params::adminpass,
  $db_host              = $odoo::params::db_host,
  $db_port              = $odoo::params::db_port,
  $db_user              = $odoo::params::db_user,
  $db_password          = $odoo::params::db_password,
  $db_filter            = $odoo::params::db_filter,

  # email options
  $email_from           = $odoo::params::email_from,
  $smtp_server          = $odoo::params::smtp_server,
  $smtp_port            = $odoo::params::smtp_port,
  $smtp_ssl             = $odoo::params::smtp_ssl,
  $smtp_user            = $odoo::params::smtp_user,
  $smtp_password        = $odoo::params::smtp_password,

  # log options
  $addons_path          = $odoo::params::addons_path,
  $logfile              = $odoo::params::logfile,
  $log_level            = $odoo::params::log_level,
  $logrotate            = $odoo::params::logrotate,

  # misc options
  $data_dir             = $odoo::params::data_dir,
  $dependency_packages  = $odoo::params::dependency_packages,
  $manage_packages      = $odoo::params::manage_packages,
  $proxy_mode           = $odoo::params::proxy_mode,

  # performance options
  $workers              = $odoo::params::workers,
  $limit_request        = $odoo::params::limit_request,
  $limit_memory_soft    = $odoo::params::limit_memory_soft,
  $limit_memory_hard    = $odoo::params::limit_memory_hard,
  $limit_time_cpu       = $odoo::params::limit_time_cpu,
  $limit_time_real      = $odoo::params::limit_time_real,
  $max_cron_threads     = $odoo::params::max_cron_threads,

) inherits odoo::params {

# validates variable data types
validate_absolute_path($config_path)
validate_absolute_path($install_path)
validate_string($service_status)
validate_string($odoo_user)
validate_string($odoo_group)

include odoo::install

}