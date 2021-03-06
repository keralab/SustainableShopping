require 'uri'
require 'net/http'
require 'net/https'
require 'rubygems'
require 'json'
class WelcomeController < ApplicationController
  def search
    @results = []
    if params[:keyword]
      url = URI("https://gateway-staging.ncrcloud.com/catalog/items/suggestions?descriptionPattern=*#{params[:keyword]}*")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(url)
      request["Content-Type"] = 'application/json'
      request["Accept"] = 'application/json'
      request["nep-application-key"] = '8a0084a165d712fd0165dbca7b5c0008'
      request["nep-service-version"] = '2.2.1:2'
      request["Authorization"] = 'Basic YWNjdDpmaXJlYmFsbC1zdGdAZmlyZWJhbGxzZXJ2aWNldXNlcjpjYXJyb3RsYQ=='
      #request["nep-organization"] = 'ncr-marche-stg'
      response = http.request(request)
      puts response.read_body
      parsed = JSON.parse(response.read_body)
      parsed["pageContent"].each do |page|
        if page["merchandiseCategory"]["nodeId"]== "Renewable" || page["merchandiseCategory"]["nodeId"] == "Fair-trade" || page["merchandiseCategory"]["nodeId"] == "Recyclable"
          @results.push(page)
        end
      end
    end
  end
end