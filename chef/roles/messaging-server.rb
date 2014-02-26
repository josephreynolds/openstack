name "messaging-server"
description "Deploy messaging server"
run_list(
  "role[openstack-base]",
  "recipe[messaging-custom]",
  "role[os-ops-messaging]"
)
