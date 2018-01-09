{% if 'VMWare' in grains['virtual'] or 'VMware' in grains['virtual'] %}
{% from "vmware-tools/map.jinja" import vmware_tools with context %}

include:
  - vmware-tools.{{ vmware_tools.env.use_module }}

{% endif %}
