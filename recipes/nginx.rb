#
# Cookbook Name:: concrete5
# Recipe:: nginx
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

# setting repo
case node['platform_family']
when 'rhel', 'fedora'
  case node['platform']
  when 'centos'
    upstream_repository = "http://nginx.org/packages/centos/#{node['platform_version'].to_i}/$basearch/"
  when 'amazon'
    upstream_repository = "http://nginx.org/packages/rhel/6/$basearch/"
  else
    upstream_repository = "http://nginx.org/packages/rhel/#{node['platform_version'].to_i}/$basearch/"
  end
end

case node['platform_family']
when 'rhel', 'fedora'
  yum_repository 'nginx' do
    description 'Nginx.org Repository'
    baseurl upstream_repository
    gpgkey  'http://nginx.org/keys/nginx_signing.key'
    action :create
  end
end

### install nginx
##node.set['nginx']['repo_source'] = 'nginx'
##node.set['nginx']['default_site_enabled'] = false
##include_recipe 'nginx::default'
package 'nginx' do
  action [:install, :upgrade]
end

# configure

template "/etc/nginx/nginx.conf" do
  #variables node[:nginx][:config]
  source "nginx/nginx.conf.erb"
  notifies :reload, 'service[nginx]'
end

%w{ php-fpm }.each do | file_name |
  template "/etc/nginx/" + file_name do
    #variables node[:nginx][:config]
    source "nginx/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

%w{ default.conf default.backend.conf }.each do | file_name |
  template "/etc/nginx/conf.d/" + file_name do
#    variables(
#      :server_name => node[:ec2][:instance_id],
#      :phpmyadmin_enable => node[:nginx][:config][:phpmyadmin_enable]
#    )
    source "nginx/conf.d/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

%W{ /var/cache/nginx /var/log/nginx /var/lib/nginx /var/tmp/nginx /var/www/concrete5 }.each do | dir_name |
  directory dir_name do
    owner 'nginx'
    group 'nginx'
    mode '0755'
    recursive true
    action :create
  end
end

service "nginx" do
  action [:enable, :start]
end
