class profile::odoo {

  include odoo::prequisites

  odoo::instance { 'odoo-demo.odoogroup.com':
    sitename  => 'odoo-demo.odoogroup.com',
    port      => 80,
    username  => 'demoer', 
    groupname => 'demoer', 
    require   => Class['odoo::prequisites'],
  }  

}

      
  
