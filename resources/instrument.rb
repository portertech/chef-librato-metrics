#
# Cookbook Name:: librato_metrics
# Resource:: instrument
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

actions :create, :update, :add

attribute :email, :kind_of => String
attribute :token, :kind_of => String
attribute :metric, :kind_of => String
attribute :source, :kind_of => String, :default => "*"
attribute :group_function, :kind_of => String, :equal_to => %w[average sum breakout], :default => "average"
attribute :color, :kind_of => String
attribute :streams, :kind_of => Array, :default => Array.new
attribute :attributes, :kind_of => Hash

def initialize(*args)
  super
  @action = :create
end
