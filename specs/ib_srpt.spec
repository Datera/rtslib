# The ib_srpt fabric module specfile.
#

# The fabric module feature set
features = acls

# Non-standard module naming scheme
kernel_module = ib_srpt

# The module uses hardware addresses
wwn_from_cmds = /var/target/fabric/probe-ib_srpt.sh

# The configfs group
configfs_group = srpt

