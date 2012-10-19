require 'net/http'
require 'json'
require 'URI'
require 'nokogiri'

module Bart
  API_HOST = 'api.bart.gov'
  SCRIPT_URLS = {
    :routes => 'route.aspx',
    :stations => 'stn.aspx',
    :etd => 'etd.aspx'
  }

  def self.default_api_key
    'EMH2-BJSB-ITEQ-95MP'
  end

  def self.routes route_num = nil, additional_params = {}
    params = {}
    if route_num.nil?
      params[:cmd] = 'routes'
    else
      params[:cmd] = 'routeinfo'
      params[:route] = route_num
      params.merge(additional_params)
    end

    path = self.path_for :routes, params
    xml = self.get_xml path

    routes = xml.css('routes').css('route').collect do |r|
      route = {}
      r.children.each do |r|
        route[r.name.to_sym] = r.text
      end
      route
    end

    return routes if route_num.nil?
    routes[0]
  end

  def self.stations orig = nil
    params = {}
    if orig.nil?
      params[:cmd] = 'stns'
    else
      params[:cmd] = 'stninfo'
      params[:orig] = orig
    end

    path = self.path_for :stations, params
    xml = self.get_xml path

    stations = xml.css('stations').css('station').collect do |s|
      station = {}
      s.children.each do |s|
        station[s.name.to_sym] = s.text
      end

      station
    end

    return stations if orig.nil?
    stations[0]
  end

  def self.real_time_info orig, additional_params = nil
    params = {}
    params[:cmd] = 'etd'
    params[:orig] = orig

    if not additional_params.nil?
      params = params.merge(additional_params)
    end

    path = self.path_for :etd, params
    xml = self.get_xml path

    xml
  end

  private

  def self.path_for what, params
    params[:key] = default_api_key
    '/api/'+SCRIPT_URLS[what]+'?'+params.collect {|k, v| "#{k.to_s}=#{URI.escape(v.to_s)}"}.join('&')
  end

  def self.get path
    req = Net::HTTP::Get.new path
    res = Net::HTTP.start(API_HOST, 80) do |http|
      http.request(req)
    end
    res.body
  end

  def self.get_xml path
    Nokogiri::XML.parse(self.get(path))
  end

  def self.get_xml_and_path_for what, params
    self.get_xml(self.path_for(what, params))
  end
end
