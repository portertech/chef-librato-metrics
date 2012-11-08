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
      @email = email
      @token = token
      @api_url = "https://" + api
    end

    def instruments
      code, body = api_request("get", "instruments")
      if code == 200
        body["instruments"]
      else
        raise "Failed to get Librato Metrics instruments"
      end
    end

    def instrument_exists?(name)
      instruments.any? do |instrument|
        instrument["name"] == name
      end
    end

    def get_instrument(name)
      instrument = instruments.select {|instrument| instrument["name"] == name }.first
      if instrument.nil?
        raise "Librato Metrics instrument '#{name}' does not exist"
      end
      instrument
    end

    def create_instrument(name, streams=[])
      instrument = {
        "name" => name,
        "streams" => streams
      }
      code, body = api_request("post", "instruments", instrument)
      if code == 201
        true
      else
        raise "Failed to create Librato Metrics instrument '#{name}' -- #{code} -- #{body}"
      end
    end

    def update_instrument(name, streams=[], addition=false)
      current_instrument = get_instrument(name)
      updated_streams = if addition
        (current_instrument["streams"] + streams).uniq
      else
        streams
      end
      if current_instrument["streams"] == updated_streams
        false
      else
        instrument = {
          "name" => name,
          "streams" => updated_streams
        }
        code, body = api_request("put", "instruments/#{current_instrument["id"]}", instrument)
        if code == 204
          true
        else
          raise "Failed to update Librato Metrics instrument '#{name}' -- #{code} -- #{body}"
        end
      end
    end

    private

    def api_request(http_method, resource, body=nil)
      uri = URI.parse(@api_url + resource)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request_uri = uri.request_uri
      request = case http_method
      when "get"
        Net::HTTP::Get.new(request_uri)
      when "post"
        Net::HTTP::Post.new(request_uri)
      when "put"
        Net::HTTP::Put.new(request_uri)
      end
      request.add_field("Content-Type", "application/json")
      request.basic_auth(@email, @token)
      request.body = body.to_json unless body.nil?
      response = http.request(request)
      response_code = response.code.to_i
      response_body = JSON.parse(response.body) rescue nil
      [response_code, response_body]
    end
  end
end
