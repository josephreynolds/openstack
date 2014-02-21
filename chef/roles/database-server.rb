name "database-server"
description "Currently MySQL Server (non-ha)"
run_list(
    "role[os-base]",
    "recipe[database-custom]",
    "recipe[openstack-ops-database::server]",
    "recipe[openstack-ops-database::openstack-db]"
)
default_attributes()
override_attributes()
