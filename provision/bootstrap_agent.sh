#!/bin/bash

HOSTNAME=$(hostname)
CE_VERSION="pc1"
BASEDIR="/opt/puppetlabs"
CONFDIR="/etc/puppetlabs"
CE_RPM_URL=""
CE_APT_URL=""
UBUNTU_VERSION=""
MODULEPATH="/vagrant/modules"

if [[ -f /etc/redhat-release ]]; then # redhat
    RELEASE=$(cat /etc/redhat-release) 
    if [[ $RELEASE =~ 6\.[0-9] ]]; then
	EL_VER="6"
	CE_RPM_URL="https://yum.puppetlabs.com/puppetlabs-release-${CE_VERSION}-el-${EL_VER}.noarch.rpm"
    elif [[ $RELEASE =~ 7\.[0-9] ]]; then
	EL_VER="7"
	CE_RPM_URL="https://yum.puppetlabs.com/puppetlabs-release-${CE_VERSION}-el-${EL_VER}.noarch.rpm"
    else
	echo "Unsupported Redhat/Centos version"
	exit 1
    fi
else # ubuntu
    DESCR="$(lsb_release -d | awk '{ print $2}')"
    if [[ $DESCR =~ Ubuntu ]]; then
	UBUNTU_VERSION="$(lsb_release -c | awk '{ print $2}')"
	CE_APT_URL="https://apt.puppetlabs.com/puppetlabs-release-${CE_VERSION}-${UBUNTU_VERSION}.deb"
    else
	echo "Unsupported OS/Release"
	exit 1
    fi
fi

if [ -x ${BASEDIR}/bin/puppet ]; then
    echo "This is an existing setup. Behaving accordingly..."
    (${BASEDIR}/bin/puppet resource service puppet ensure=stopped) || (echo "Failed to stop puppet" && exit 1)
else
    echo "This is a new setup. Behaving accordingly..."
    if [[ ! -z $CE_RPM_URL ]]; then
	echo "Getting rid of firewalld..."
	if systemctl status firewalld > /dev/null; then
	    systemctl stop firewalld
	fi
	echo "Installing Puppetlabs repository..."
	(rpm -hiv "${CE_URL}") || (echo "Failed to install ${CE_URL}" && exit 1)
	echo "Installing puppet agent..."
	(yum -y install puppet-agent) || (echo "Failed to install puppet agent" && exit 1)
    elif [[ "${UBUNTU_VERSION}" == "trusty" ]];then
	echo "Fixing fqdn for ubuntu..."
	hostname ${CLIENTNAME}
	echo "${CLIENTNAME}" > /etc/hostname
	echo "Installing Puppetlabs repository..."
	FILE=$(mktemp)
	(wget "${CE_APT_URL}" -qO $FILE) || (echo "Failed to retrieve ${CE_APT_URL}" && exit 1)
	(dpkg --install $FILE; rm $FILE; apt-get update) || (echo "Failed to install ${FILE}" && exit 1)
	echo "Installing puppet agent..."
	(apt-get -y install puppet-agent) || (echo "Failed to install puppet agent" && exit 1)
    else
	echo "Unsupported OS/Release"
	exit 1

    fi
    if [[ -f /etc/profile.d/puppet-agent.sh ]]; then
	. /etc/profile.d/puppet-agent.sh
    else
	"Could not set PATH. Puppet agent install failed?"
	exit 1
    fi
fi











