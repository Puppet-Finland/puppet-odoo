#!/bin/bash

BASEDIR="/opt/puppetlabs"
MODULEPATH="/vagrant/site:/vagrant/modules"

# For the associative array
if [[ "${BASH_VERSINFO}" -lt 4 ]]; then
    echo "BASH 4 required"
    exit 1
fi

# Pin to module versions known to work
declare -A MODULES_TO_INSTALL=(["puppetlabs-ntp"]="4.1.2" ["puppetlabs-postgresql"]="4.7.1" ["jfryman-nginx"]="0.3.0" ["bashtoni-timezone"]="1.0.0" ["hunner-hiera"]="2.0.1" ["puppetlabs-vcsrepo"]="1.0.2" ["maestrodev-wget"]="1.7.3" ["rehan-git"]="0.1.3" )

for module in "${!MODULES_TO_INSTALL[@]}"; do
    ${BASEDIR}/bin/puppet module install --modulepath=${MODULEPATH} $module --version ${MODULES_TO_INSTALL["$module"]}
done


echo "Provisioning odoo development server..."
(${BASEDIR}/bin/puppet apply --modulepath=${MODULEPATH} -e "include role::odooserver" --verbose) || (echo "Failed to bootstrap odoo development server" && exit 1)











