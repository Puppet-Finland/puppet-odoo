class profile::base {

  include '::ntp'
  # include git
  class { 'timezone':
    region   => 'Europe',
    locality => 'Helsinki',
  }

}
