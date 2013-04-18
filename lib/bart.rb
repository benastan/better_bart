require 'json'
require 'bart/requestable'
require 'bart/fetchable'
require 'bart/route'
require 'bart/station'
require 'bart/departure'

module Bart
  def self.[](arg)
    if arg.is_a?(String)
      Bart::Station[arg.to_sym]
    elsif arg.is_a?(Symbol)
      Bart::Station[arg]
    elsif arg.is_a?(DateTime)
      # schedule finder
    elsif arg.is_a?(Hash)
      Bart::Route[arg]
    elsif arg.is_a?(Numeric)
      Bart::Route[arg]
    end
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

  def self.get(resource, params)
    Bart::Request.get(resource, params)
  end
end
