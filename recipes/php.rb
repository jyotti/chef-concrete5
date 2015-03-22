#
# Cookbook Name:: concrete5
# Recipe:: php
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
case node.platform
when 'centos'
  include_recipe "yum-ius::default"
end

# php54 install
packages = %w{ php54 php54-cli php54-fpm php54-devel php54-mbstring php54-gd php-pear php54-xml php54-mcrypt php54-mysqlnd php54-pdo php54-pecl-apc php54-pecl-memcache }
packages.each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# configures
%w{ php.ini php.d/apc.ini php-fpm.d/www.conf }.each do | file_name |
  template "/etc/" + file_name do
    #variables node[:php][:config]
    source "php/" + file_name + ".erb"
    notifies :reload, 'service[php-fpm]'
  end
end

%w{ /var/tmp/php /var/tmp/php/session /var/log/php-fpm }.each do | dir_name |
  directory dir_name do
    owner 'nginx'
    group 'nginx'
    mode 00755
    recursive true
    action :create
  end
end

service "php-fpm" do
  action [:enable, :start]
end
