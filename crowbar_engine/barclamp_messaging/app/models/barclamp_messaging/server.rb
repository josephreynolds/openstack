# Copyright 2013, Dell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class BarclampMessaging::Server < Role
  include BarclampOpenstack

# Event triggers for node creation and destruction.
  # roles should override if they want to handle node addition
  def on_node_create(node)
    Rails.logger.info("on_node_create: #{node}")
    true
  end

  # Event triggers for node creation and destruction.
  # roles should override if they want to handle node destruction
  def on_node_delete(node)
    Rails.logger.info("on_node_delete: #{node}")
    true
  end

  # Event hook that will be called every time a node is saved if any attributes changed.
  # Roles that are interested in watching nodes to see what has changed should
  # implement this hook.
  def on_node_change(node)
    Rails.logger.info("on_node_change: #{node}")
    true
  end

  # Event hook that is called whenever a new deployment role is bound to a deployment.
  # Roles that need do something on a per-deployment basis should override this
  def on_deployment_create(dr)
    DeploymentRole.transaction do
      Rails.logger.info("on_deployment_create: #{dr}")
      messaging_user_id = "guest"
      messaging_password ="guestpassword"

      #setup the encrypted data bag with temporary hardcoded values.
      Rails.logger.info("Adding encrypted credentials into encrypted data bags")
      store_credential( "messaging", "user", messaging_user_id, messaging_password)

      d = dr.data
      d.deep_merge!(
            {
              "crowbar_messaging" => 
                { 
                  "mq" =>
                  { 
                    "user" => messaging_user_id
                  }
                }   
            }
      )
      dr.data = d
      dr.save!
      Rails.logger.info("Merged user info.#{dr}")
    end
  end

  # Event hook that is called whenever a deployment role is deleted from a deployment.
  def on_deployment_delete(dr)
    Rails.logger.info("on_deployment_delete: #{dr}")
    true
  end

 
end
