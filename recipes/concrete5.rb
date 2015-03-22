#
# Cookbook Name:: concrete5
# Recipe:: concrete5
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
directory node['concrete5']['install_dir'] do
  user  'nginx'
  group 'nginx'
  mode  '0755'
  action :create
end

##git node['concrete5']['install_dir'] do
##  repository  node['concrete5']['git_repository']
##  revision    node['concrete5']['git_revision']
##  user        'nginx'
##  group       'nginx'
##  action      :checkout
##end

ark 'web' do
  url 'http://concrete5-japan.org/files/1114/1982/1355/concrete5.6.3.2.ja.zip'
  path node['concrete5']['install_dir']
  owner 'nginx'
  action :put
end
