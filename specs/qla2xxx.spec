# The qla2xxx fabric module specfile.
#

# The qla2xxx fabric module feature set
features = acls

# Non-standard module naming scheme
kernel_module = tcm_qla2xxx

# The module uses hardware addresses
wwn_from_cmds = /var/target/fabric/probe-qla2xxx.sh
