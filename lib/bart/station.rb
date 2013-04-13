module Bart
  class Station
    attr_accessor :routes, :address, :city, :state, :latitude, :longitude, :abbr, :name
    @stations = {}
    @fetch_all = true

    class << self
      def new(attrs)
        station = super(attrs)
        @stations[station.abbr.downcase.to_sym] = station
        station
      end

      def [](arg)
        if (station = @stations[arg]).nil?
          station = Station.new(arg)
        else
          station.fetch!
        end
        station
      end

      def []=(arg, val)
        @stations[arg] = val
      end

      def all
        fetch! if fetch?
        @stations
      end

      def fetch?
        @fetch_all == true
      end

      def fetch!
        @fetch_all = false
        extract_stations(Bart::Request.get(:stations))
      end

      def extract_stations(ox)
        ox.locate('*/stations/station').each do |ox_element|
          from_ox(ox_element)
        end
      end

      def ox_to_hash(ox_element)
        ox_element.nodes.inject({}) do |station, ox_child|
          station[ox_child.name.to_sym] = ox_child.text
          station
        end
      end

      def from_ox(ox_element)
        new(ox_to_hash(ox_element))
      end
    end

    def initialize(arg)
      if arg.is_a?(Hash)
        parse_attributes(arg)
      elsif arg.is_a?(String)
        @abbr = arg.to_sym
        fetch!
      elsif arg.is_a?(Symbol)
        @abbr = arg
        fetch!
      end
    end

    def parse_attributes(attrs)
      @name = attrs[:name]
      @abbr = attrs[:abbr].downcase.to_sym
      @latitude = attrs[:gtfs_latitude]
      @longitude = attrs[:gtfs_longitude]
      @address = attrs[:address]
      @city = attrs[:city]
      @state = attrs[:state]
      @zipcode = attrs[:zipcode]
    end

    def fetch?
      @routes.nil?
    end

    def fetch!
      @ox = Bart::Request.get(:station, :orig => self.abbr.to_s.upcase).locate('*/stations/station')[0]
      attrs = self.class.ox_to_hash(@ox)
      parse_attributes(attrs)
    end

    def routes
      fetch_routes! unless routes_fetched?
      @routes
    end

    private

    def fetch_routes!
      fetch! if fetch?

      @routes = @ox.locate('*/route').inject({}) do |memo, route|
        route_number = route.nodes[0].split(' ')[1].to_i
        route = Bart[route_number]
        key = route.origin == self.abbr ? {:to => route.destination} : {:from => route.origin}
        memo[key] = route
        memo
      end
    end

    def routes_fetched?
      ! @routes.nil?
    end
  end
end
