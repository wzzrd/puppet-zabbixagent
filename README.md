# Zabbix Agent Puppet Module
This module manages the zabbix agent for a monitored machine.

This module has been tested against Puppet 3.6 and Satellite 6.1.1 on RHEL6 and
RHEL7.

## Usage

```puppet
class { 'zabbixagent':
  servers  => 'zabbix.example.com', # Optional: defaults to localhost (accepts an array)
  hostname => 'web01.example.com' # Optional: defaults to the fully qualified domain name of the machine
}
```

This is the only configuration supported at this time. Custom user parameters may
come at a later date. If there is any other configuration that ought to be made available,
then please let me know.

### Authors
* Scott Smerchek (@smerchek)
* Maxim Burgerhout 

### Contributors
* Martijn Storck (@martijn) - Added CentOS support
