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

node.override['rabbitmq']['nodename'] = "rabbit@#{node[:hostname]}"
node.override['openstack']['endpoints']['mq']['host'] = node.address( "admin", IP::IP4 ).addr
node.default['openstack']['mq']['user'] = node['crowbar_messaging']['mq']['user']
node.default['openstack']['secret']['key_path'] = '/var/chef/data_bags/openstack_data_bag_secret'
