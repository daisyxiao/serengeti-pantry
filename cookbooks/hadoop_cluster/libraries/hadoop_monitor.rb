#
#   Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

module HadoopCluster
  ACTION_INSTALL_PACKAGE = 'Installing package <obj>'
  ACTION_START_SERVICE = 'Starting service <obj>'

  # Save Bootstrap Status to Chef::Node.
  def set_bootstrap_action(act = '', obj = '', run = false)
    act = act.gsub(/<obj>/, obj)
    ruby_block "#{obj}" do
      block do
        Chef::Log.info "Set Bootstrap action to '#{act}'"
        attrs = node[:provision] ? node[:provision].to_hash : Hash.new
        attrs['action'] = act
        node[:provision] = attrs
        node.save
      end
      action run ? :create : :nothing
    end
  end

  class Chef::Recipe ; include HadoopCluster ; end
  class Chef::Resource::Directory ; include HadoopCluster ; end
end
