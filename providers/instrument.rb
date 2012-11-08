#
# Cookbook Name:: librato_metrics
# Provider:: instrument
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
  @streams = if new_resource.metric
    [
      {
        "metric" => new_resource.metric,
        "source" => new_resource.source,
        "group_function" => new_resource.group_function
      }
    ]
  else
    new_resource.streams
  end
end

action :create do
  unless @librato.instrument_exists?(new_resource.name)
    @librato.create_instrument(new_resource.name, @streams)
    new_resource.updated_by_last_action(true)
  end
end

action :update do
  if @librato.update_instrument(new_resource.name, @streams)
    new_resource.updated_by_last_action(true)
  end
end

action :add do
  instrument = @librato.get_instrument(new_resource.name)
  streams = (instrument["streams"] + @streams).uniq
  if @librato.update_instrument(new_resource.name, streams)
    new_resource.updated_by_last_action(true)
  end
end
