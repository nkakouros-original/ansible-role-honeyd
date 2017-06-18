# ansible-role-honeyd

This role installs and configures [Honeyd](http://www.honeyd.org/). 

## But why? HoneyD is dead!
The [original HoneyD version](https://github.com/provos/honeyd) was last updated in 2008. Later, [DataSoft maintained](https://github.com/DataSoft/Honeyd/commits/master) the project until 2013. This is the latest version known (at least to me). This version works well even today and through updating the fingrerprints it can still do the trick. Look [here](https://github.com/DataSoft/Honeyd/issues/91) for more information.

## What this role does
It will download honeyd from DataSoft and compile it. Optionally, the scripts from the original honeyd can be placed in `/usr/share/honeyd` alongside the ones from DataSoft. Some of the latter ones have dependencies on [Nova](https://github.com/DataSoft/Nova) and my personal experience was not the best when trying to use them. Configuration files and database files are placed in `/etc/honeyd`. It will also create a systemd service to start/stop honeyd (service file is placed in `/etc/systemd/system`).

## Requirements - Dependencies
None.

## Variables
Taken directly from [defaults/main.yml](https://github.com/tterranigma/ansible-role-honeyd/blob/master/defaults/main.yml):
```yml
honeyd_enabled: yes                                                             # Turns off the role completely

honeyd_datasoft_repo: 'https://codeload.github.com/DataSoft/Honeyd/zip/master'  # Where honeyd will be downloaded from
honeyd_provos_repo: 'https://codeload.github.com/provos/honeyd/zip/master'      # For the original service scripts
honeyd_provos_scripts: yes                                                      # Enables installing original service scripts

honeyd_user: nobody                                                             # The user honeyd will run as
honeyd_group: nogroup                                                           # The group honeyd will run as

honeyd_interface: ens4                                                          # The interface honeyd will listen on
honeyd_network: 10.0.0.0/8                                                      # Packets destined to this subnet will be captured by honeyd

honeyd_use_current_nmap_os_db: yes                                              # Update the OS db
honeyd_use_current_nmap_mac_prefixes: yes                                       # Update MAC prefixes
honeyd_force_db_update_check: no                                                # If yes, it will cause ansible to check for updates in the OS/MAC databases

honeyd_packet_log: yes                                                          # Enables packet logging
honeyd_service_log: yes                                                         # Enables service logging
honeyd_dhcp_log: yes                                                            # Enables DHCP logging

honeyd_split_config: yes                                                        # Split configuration into one file per defined honeypot
honeyd_use_config: ''                                                           # a local file to upload and integrate with the rest of the configuration

honeyd_honeypots:                                                               # Example of how honeypots are defined. All the supported
  routerone:                                                                    # options are shown.
    personality: Cisco 2811 router (IOS 15.1)
    tcp:
      default: reset
      23: script=original/router-telnet.pl
    bind: 10.100.0.1
    # manufacturer: cisco
    # dhcp: eth0
  netbsd:
    personality: Linux 2.6.27 (Ubuntu 8.10)
    manufacturer: intel
    tcp:
      default: reset
      22: proxy=\$ipsrc:22
      80: script=original/web.sh
      22022: script=linux/ssh.sh
    bind: 10.100.0.134
```
