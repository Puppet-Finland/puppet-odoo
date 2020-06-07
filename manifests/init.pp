#
# @summary Manage Odoo
#
class odoo(

  # install options
  Stdlib::Absolutepath $odoo_executable,
  Stdlib::HTTPSUrl $odoo_repo_url,
  String $branch,
  Stdlib::Absolutepath $config_path,
  Stdlib::Absolutepath $install_path,
  String $service_status,
  String $odoo_user,
  String $odoo_group,
  String $odoo_repouser,
  Stdlib::Absolutepath $home_path,
  Stdlib::Absolutepath $script_path,
  Array[String] $scripts,
  Stdlib::Absolutepath $pidpath,

  # database options
  String $db_host,
  Integer $db_port,
  String $db_user,
  String $db_name,
  String $db_password,
  String $db_filter,
  Boolean $listdb,
  Boolean $without_demo,
  String $psycogreen_version,

  # email options
  String $email_from,
  String $smtp_server,
  Integer $smtp_port,
  Boolean $smtp_ssl,
  String $smtp_user,
  String $smtp_password,

  # log options
  Array[Stdlib::Absolutepath] $addons_path,
  Stdlib::Absolutepath $logfile,
  Stdlib::Absolutepath $logdir,
  String $log_level,
  Integer $logrotate,

  # misc options
  String $data_dir,
  Array[String] $dependency_packages,
  Boolean $manage_packages,
  Boolean $proxy_mode,
  String $lang,
  String $wkhtmltox_source,
  Array[String] $wkhtmltox_dependency_packages,
  Array[String] $fontconfig_dependency_packages,

  # performance options
  Integer $workers,
  Integer $limit_request,
  Integer $limit_memory_soft,
  Integer $limit_memory_hard,
  Integer $limit_time_cpu,
  Integer $limit_time_real,
  Integer $max_cron_threads,

  String $admin_password = 'changeme',
  Boolean $manage_db = false,
) {

  validate_absolute_path($config_path)
  validate_absolute_path($install_path)
  validate_string($service_status)
  validate_string($odoo_user)
  validate_string($odoo_group)

  contain '::odoo::install'
  contain '::odoo::config'
  contain '::odoo::service'

  Class['::odoo::install'] -> Class['::odoo::config'] ~> Class['::odoo::service']
}
