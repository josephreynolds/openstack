name "os-ops-messaging"
description "Currently RabbitMQ Server (non-ha)"
run_list(
  "role[os-base]",
  "recipe[messaging]",
  "recipe[openstack-ops-messaging::server]"
)
