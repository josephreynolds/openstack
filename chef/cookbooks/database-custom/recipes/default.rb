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
#

node.override['build_essential']['compiletime'] = false

#setup database address to be used by other Os roles
v4addr=node.address("admin",IP::IP4)
v6addr=node.address("admin",IP::IP6)
node.normal["crowbar"]["database"]["server"]["v4addr"]=v4addr.addr if v4addr
node.normal["crowbar"]["database"]["server"]["v6addr"]=v6addr.addr if v6addr

Chef::Log.info("Database Server: v4addr #{ node["crowbar"]["database"]["server"]}")


db_bind_address = v4addr.addr if v4addr
node.override['openstack']['endpoints']['db']['host'] = db_bind_address
node.override['openstack']['db']['compute']['host'] = db_bind_address
node.override['openstack']['db']['identity']['host'] = db_bind_address
node.override['openstack']['db']['network']['host'] = db_bind_address
node.override['openstack']['db']['image']['host'] = db_bind_address
node.override['openstack']['db']['dashboard']['host'] = db_bind_address
node.override['openstack']['db']['metering']['host'] = db_bind_address
node.override['openstack']['db']['block-storage']['host'] = db_bind_address
node.override['openstack']['db']['orchestration']['host'] = db_bind_address
node.override['mysql']['root_network_acl'] =  db_bind_address


package 'make' do
  action :nothing
end.run_action(:install)

node.default['openstack']['secret']['key_path'] = '/var/chef/data_bags/openstack_data_bag_secret'

node.default['openstack']['db']['identity']['username'] = node['crowbar']['db']['identity']['username']
node.default['openstack']['db']['compute']['username'] = node['crowbar']['db']['compute']['username']
node.default['openstack']['db']['image']['username'] = node['crowbar']['db']['image']['username']
node.default['openstack']['db']['network']['username'] = node['crowbar']['db']['network']['username']
node.default['openstack']['db']['dashboard']['username'] = node['crowbar']['db']['dashboard']['username']
node.default['openstack']['db']['metering']['username'] = node['crowbar']['db']['metering']['username']
node.default['openstack']['db']['block-storage']['username'] = node['crowbar']['db']['block-storage']['username']
node.default['openstack']['db']['orchestration']['username'] = node['crowbar']['db']['orchestration']['username']