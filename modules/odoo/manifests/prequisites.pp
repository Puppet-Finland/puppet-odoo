# == Class: odoo::prequisites
#
class odoo::prequisites {
  ensure_packages($odoo::dependency_packages)
}
