# The tcm_fc fabric module specfile.
#

# The fabric module feature set
features = acls

# Non-standard module naming scheme
kernel_module = tcm_fc

# The module uses hardware addresses
wwn_from_cmds = /var/target/fabric/probe-tcm_fc.sh

# The configfs group
configfs_group = fc
