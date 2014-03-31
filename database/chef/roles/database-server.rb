name "database-server"
description "Currently MySQL Server (non-ha)"
run_list(
    "role[openstack-base]",
    "recipe[database-custom]",
    "role[os-ops-database]",
    "recipe[openstack-ops-database::openstack-db]"
)
default_attributes()
override_attributes()
