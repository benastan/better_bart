require 'faraday'
require 'ox'

module Bart
  module Request
    RESOURCES = {
      :routes => 'route.aspx',
      :route => 'route.aspx',
      :stations => 'stn.aspx',
      :etd => 'etd.aspx'
    }
    COMMANDS = {
      :route => 'routeinfo',
      :routes => 'routes'
    }
    API_KEY = 'EMH2-BJSB-ITEQ-95MP'
    HOSTNAME = 'api.bart.gov'

    def self.parametrize(params)
      params.collect do |k, v|
        "#{k.to_s}=#{URI.escape(v.to_s)}"
      end.join('&')
    end

    def self.get(resource, params = {})
      filename = RESOURCES[resource]
      params[:cmd] = COMMANDS[resource]
      params[:key] = API_KEY
      querystring = '?'+parametrize(params)
      path = "#{File.join('http://', HOSTNAME, 'api', filename)}#{querystring}"
      response = Faraday.get(path)
      xml_string = response.body
      Ox.parse(xml_string)
    end
  end
end
