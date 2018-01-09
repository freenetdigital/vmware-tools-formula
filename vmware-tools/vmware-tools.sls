{% if 'VMWare' in grains['virtual'] or 'VMware' in grains['virtual'] %}
{% from "vmware-tools/map.jinja" import vmware_tools with context %}
remove-previous-vmware-versions:
  cmd.run:
    - name: rm VMwareTools*
    - cwd: /root/
    - prereq:
      - file: /root/{{ vmware_tools.latest }}
    - onlyif: ls VMwareTools*

/root/{{ vmware_tools.latest }}:
  file.managed:
    - source: {{ vmware_tools.source }}
    - source_hash: {{ vmware_tools.hash }}
    - user: root
    - group: root

remove-/root/vmware-tools-distrib:
 file.absent:
    - name: /root/vmware-tools-distrib
    - onchanges:
      - file: /root/{{ vmware_tools.latest }}
    - onlyif: ls /root/vmware-tools-distrib

command-untar-{{ vmware_tools.latest }}:
  cmd.run:
    - name: tar -xf /root/{{ vmware_tools.latest }}
    - cwd: /root/
    - onchanges:
      - file: /root/{{ vmware_tools.latest }}

command-upgrade-vmware-tools:
  cmd.run:
    - name: ./vmware-install.pl -d
    - cwd: /root/vmware-tools-distrib/
    - output_loglevel: quiet
    - onchanges:
      - file: /root/{{ vmware_tools.latest }}
    - onlyif: ls /root/vmware-tools-distrib/vmware-install.pl

{% if salt['file.directory_exists' ]('/root/vmware-tools-distrib/') %}
command-reinit-vmware-tools:
  cmd.run:
    - name: ./vmware-install.pl -d
    - cwd: /root/vmware-tools-distrib/
    - output_loglevel: quiet
    - unless: {{ vmware_tools.env.check_command }}
{% endif %}
{% endif %}
