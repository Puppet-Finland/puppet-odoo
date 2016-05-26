class profile::database {

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
  }
  
  class { 'postgresql::server':
    listen_addresses => '*',
    require          => Class['postgresql::globals']
  }
  
}

      
  
