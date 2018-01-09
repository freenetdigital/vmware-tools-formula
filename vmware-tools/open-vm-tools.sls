{% if 'VMWare' in grains['virtual'] or 'VMware' in grains['virtual'] %}
{% from "vmware-tools/map.jinja" import vmware_tools with context %}

package-install-open-vm-tools:
  pkg.installed:
    - pkgs:
      - {{ vmware_tools.env.package_name }}

service-open-vm-tools:
  service.running:
    - name: {{ vmware_tools.env.service_name }}
    - enable: True

{% endif %}
