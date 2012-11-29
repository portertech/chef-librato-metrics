#
# Cookbook Name:: librato_metrics
# Provider:: metric
#
# Copyright 2012, Sean Porter Consulting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def load_current_resource
  email = new_resource.email || node.librato_metrics.email
  token = new_resource.token || node.librato_metrics.token
  @librato = Librato::Metrics.new(email, token)
  @parameters = {
    "display_name" => new_resource.display_name,
    "description" => new_resource.description,
    "period" => new_resource.period,
    "attributes" => new_resource.attributes
  }
end

action :update do
  begin
    if @librato.update_metric(new_resource.name, new_resource.type, @parameters)
      new_resource.updated_by_last_action(true)
    end
  rescue => error
    Chef::Log.warn(error.to_s)
  end
end

action :delete do
  begin
    if @librato.delete_metric(new_resource.name)
      new_resource.updated_by_last_action(true)
    end
  rescue => error
    Chef::Log.warn(error.to_s)
  end
end
