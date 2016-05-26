class profile::website {

  include nginx

  nginx::resource::vhost { 'odoo-demo.odoogroup.com':
    listen_port => 80,
    proxy       => "http://localhost:8069",
  }
  
}

      
  
