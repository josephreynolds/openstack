# Copyright 2014, Dell
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

class BarclampMessaging::Server < BarclampChef::Server
  include BarclampOpenstack
  
  # If the user has edited the messaging server node_role when deploment is in proposed state override the credentials 
  # in the encrypted data bag when it's moved to todo state.
  def on_todo(node_role, *args)
    Rails.logger.info "Override for #{self.class.to_s}.on_todo event: #{node_role.role.name} on #{node_role.node.name} "

    nrd= node_role.data
    # be paranoid about setting credentials from user data, make sure all requirements are met otherwise except defaults which 
    # were created in on_deployment_create hook.  TODO perhaps encrypt in the controller and do not persist password attrib?
    if(!nrd.nil? && nrd != {} && !nrd["crowbar_messaging"]["mq"]["user"].nil? && !nrd["crowbar_messaging"]["mq"]["password"].nil?)
      messaging_user_id = nrd["crowbar_messaging"]["mq"]["user"]
      messaging_password = nrd["crowbar_messaging"]["mq"]["password"]
      #setup the encrypted data bag with temporary hardcoded values.
      Rails.logger.info("on_todo: Adding encrypted credentials into encrypted data bags")
      store_credential( "messaging", "user", messaging_user_id, messaging_password)
    end
  end



  # Event hook that is called whenever a new deployment role is bound to a deployment.
  # Roles that need do something on a per-deployment basis should override this
  def on_deployment_create(dr)
    Rails.logger.info("Override for #{self.class.to_s}.on_deployment_create #{dr}")

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
end
