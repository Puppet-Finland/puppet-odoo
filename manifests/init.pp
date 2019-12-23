#
# == Class: odoo
#
# private class 
class odoo (

  assert_private()
  
  # install options
  String $odoo_repo_url              = $odoo::params::odoo_repo_url,
  String $branch                     = $odoo::params::branch,
  String $config_path                = $odoo::params::config_path,
  String $install_path               = $odoo::params::install_path,
  String $service_status             = $odoo::params::service_status,
  String $odoo_user                  = $odoo::params::odoo_user,
  String $odoo_group                 = $odoo::params::odoo_group,
  String $odoo_repouser              = $odoo::params::odoo_repouser,
  String $git_sshkey                 = $odoo::params::git_sshkey,

  # database options
  String $adminpass                  = $odoo::params::adminpass,
  String $db_host                    = $odoo::params::db_host,
  Integer $db_port                   = $odoo::params::db_port,
  String $db_user                    = $odoo::params::db_user,
  String $db_name                    = $odoo::params::db_name,
  String $db_password                = $odoo::params::db_password,
  String $db_filter                  = $odoo::params::db_filter,
  String $list_db                    = $odoo::params::list_db,
  String $without_demo               = $odoo::params::without_demo,

  # email options
  String $email_from                 = $odoo::params::email_from,
  String $smtp_server                = $odoo::params::smtp_server,
  Integer $smtp_port                 = $odoo::params::smtp_port,
  Boolean $smtp_ssl                  = $odoo::params::smtp_ssl,
  String $smtp_user                  = $odoo::params::smtp_user,
  String $smtp_password              = $odoo::params::smtp_password,

  # log options
  String $addons_path                = $odoo::params::addons_path,
  String $logfile                    = $odoo::params::logfile,
  String $logdir                     = $odoo::params::logfile,
  String $log_level                  = $odoo::params::log_level,
  Integer $logrotate                 = $odoo::params::logrotate,

  # misc options
  String $data_dir                   = $odoo::params::data_dir,
  Array[String] $dependency_packages = $odoo::params::dependency_packages,
  Boolean $manage_packages           = $odoo::params::manage_packages,
  Boolean $proxy_mode                = $odoo::params::proxy_mode,
  String $lang                       = $odoo::params::lang,

  # performance options
  Integer $workers                   = $odoo::params::workers,
  Integer $limit_request             = $odoo::params::limit_request,
  Integer $limit_memory_soft         = $odoo::params::limit_memory_soft,
  Integer $limit_memory_hard         = $odoo::params::limit_memory_hard,
  Integer $limit_time_cpu            = $odoo::params::limit_time_cpu,
  Integer $limit_time_real           = $odoo::params::limit_time_real,
  Integer $max_cron_threads          = $odoo::params::max_cron_threads,

) inherits odoo::params {

  validate_absolute_path($config_path)
  validate_absolute_path($install_path)
  validate_string($service_status)
  validate_string($odoo_user)
  validate_string($odoo_group)

  Class['::odoo::install'] -> Class['::odoo::config'] -> Class['::odoo::service']

  contain '::odoo::install'
  contain '::odoo::config'
  contain '::odoo::service'

}
