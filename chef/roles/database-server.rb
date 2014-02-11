name "database-server"
description "Currently MySQL Server (non-ha)"
run_list(
    "role[os-base]",
    "recipe[custom]",
    "recipe[openstack-ops-database::server]"
)
default_attributes()
override_attributes()
