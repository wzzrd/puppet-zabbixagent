# Class: zabbixagent
#
# This module manages the zabbix agent on a monitored machine.
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class zabbixagent(
  $servers = '',
  $hostname = '',
) {
  $servers_real = $servers ? {
    ''      => 'localhost',
    default => $servers,
  }
  $hostname_real = $hostname ? {
    ''      => $::fqdn,
    default => $hostname,
  }

  Package <| |> -> Ini_setting <| |>

  case $::operatingsystem {
    centos: {
      include epel

      package {'zabbix-agent' :
        ensure  => installed,
        require => Yumrepo["epel"]
      }
    }

    redhat: {
      package {'zabbix-agent':
        ensure  => installed,
      }
    }

    debian, ubuntu: {
      package {'zabbix-agent' :
        ensure  => installed
      }
    }
  }

  case $::operatingsystem {
    debian, ubuntu, centos, redhat: {
      service {'zabbix-agent' :
        ensure  => running,
        enable  => true,
        require => Package['zabbix-agent'],
      }

      ini_setting { 'servers setting':
        ensure  => present,
        path    => '/etc/zabbix/zabbix_agentd.conf',
        section => '',
        setting => 'Server',
        value   => join(flatten([$servers_real]), ','),
        notify  => Service['zabbix-agent'],
      }

      ini_setting { 'hostname setting':
        ensure  => present,
        path    => '/etc/zabbix/zabbix_agentd.conf',
        section => '',
        setting => 'Hostname',
        value   => $hostname_real,
        notify  => Service['zabbix-agent'],
      }

      ini_setting { 'Include setting':
        ensure  => present,
        path    => '/etc/zabbix/zabbix_agentd.conf',
        section => '',
        setting => 'Include',
        value   => '/etc/zabbix/zabbix_agentd/',
        notify  => Service['zabbix-agent'],
      }

      file { '/etc/zabbix/zabbix_agentd':
        ensure  => directory,
        require => Package['zabbix-agent'],
      }
    }
    default: { notice "Unsupported operatingsystem  ${::operatingsystem}" }
  }
}
