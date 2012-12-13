#
# Cookbook Name:: librato_metrics
# Provider:: dashboard
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
  @instruments = if new_resource.instrument
    begin
      instrument = @librato.get_instrument(new_resource.instrument)
      [{"id" => instrument["id"]}]
    rescue => error
      Chef::Log.warn(error.to_s)
      Array.new
    end
  else
    new_resource.instruments.map { |instrument_name|
      begin
        instrument = @librato.get_instrument(instrument_name)
        {"id" => instrument["id"]}
      rescue => error
        Chef::Log.warn(error.to_s)
        nil
      end
    }.compact
  end
end

action :create do
  begin
    unless @librato.dashboard_exists?(new_resource.name)
      @librato.create_dashboard(new_resource.name, @instruments)
      new_resource.updated_by_last_action(true)
    end
  rescue => error
    Chef::Log.warn(error.to_s)
  end
end

action :update do
  begin
    if @librato.update_dashboard(new_resource.name, @instruments)
      new_resource.updated_by_last_action(true)
    end
  rescue => error
    Chef::Log.warn(error.to_s)
  end
end

action :add do
  begin
    if @librato.update_dashboard(new_resource.name, @instruments, true)
      new_resource.updated_by_last_action(true)
    end
  rescue => error
    Chef::Log.warn(error.to_s)
  end
end
