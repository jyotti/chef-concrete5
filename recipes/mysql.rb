#
# Cookbook Name:: concrete5
# Recipe:: mysql
#
# Copyright (C) 2015 Atsushi Nakajyo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# mysql-server install
mysql_service 'default' do
  version '5.6'
  #bind_address '0.0.0.0'
  port '3306'
  #data_dir '/data'
  initial_root_password 'root'
  action [:create, :start]
end

execute "mysql-install-concrete5" do
  #if node['mysql']['server_root_password'] == ''
  #  command "mysql -h #{node[:concrete5][:db][:host]} -u root < /root/concrete5.sql"
  #else
  #  command "mysql -h #{node[:concrete5][:db][:host]} -u root -p#{node['mysql']['server_root_password']} < /root/concrete5.sql"
  #end
    command "mysql -h 127.0.0.1 -u root -proot < /root/concrete5.sql"
  action :nothing
end

template "/root/concrete5.sql" do
  source "concrete5.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :dbuser => "concrete5",
    :dbpass => "concrete5",
    :dbname => "concrete5",
    :dbhost => "127.0.0.1"
  )
  notifies :run, "execute[mysql-install-concrete5]", :immediately
end
