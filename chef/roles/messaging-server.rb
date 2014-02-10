name "messaging-server"
description "Deploy messaging server"
run_list(
  "recipe[messaging]",
  "role[os-ops-messaging]"
)
