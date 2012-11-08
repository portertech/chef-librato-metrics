#
# Cookbook Name:: librato_metrics
# Library:: librato_metrics
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

module Librato
  class Metrics
    def initialize(email, token, api="metrics-api.librato.com/v1/")
      @api = "https://#{email}:#{token}@#{api}"
    end

    def instrument_exists?(name)
      status, body = http_request("get", "instruments")
      if status == 200 && !body.nil?
        body["instruments"].any? do |instrument|
          instrument["name"] == name
        end
      else
        false
      end
    end

    def create_instrument(name, streams=[])
      body = {
        "name" => name,
        "streams" => streams
      }
      http_request("post", "instruments", body).first == 201
    end

    private

    def http_request(http_method, resource, body=nil)
      uri = URI.parse(@api + resource)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request_uri = uri.request_uri
      request = case http_method
      when "get"
        Net::HTTP::Get.new(request_uri)
      when "post"
        Net::HTTP::Post.new(request_uri)
      end
      request.add_field("Content-Type", "application/json")
      request.basic_auth(uri.user, uri.password)
      request.body = body
      response = http.request(request)
      response_body = JSON.parse(response.body) rescue nil
      response_status = response.status.to_i
      [response_status, response_body]
    end
  end
end
