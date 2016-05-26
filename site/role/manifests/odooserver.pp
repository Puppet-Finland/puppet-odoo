class role::odooserver {

  include profile::base
  include profile::database
  include profile::odoo
  include profile::website

}
