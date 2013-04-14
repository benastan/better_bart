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
        @result = Bart::Request.get(:stations)['root']['stations'].values
        @result.each do |station|
          new(station)
        end
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
      @name = attrs['name']
      @abbr = attrs['abbr'].downcase.to_sym
      @latitude = attrs['gtfs_latitude']
      @longitude = attrs['gtfs_longitude']
      @address = attrs['address']
      @city = attrs['city']
      @state = attrs['state']
      @zipcode = attrs['zipcode']
    end

    def fetch?
      @routes.nil?
    end

    def fetch!
      @result = Bart::Request.get(:station, :orig => self.abbr.to_s.upcase)
      @result =  @result['root']['stations'].values.first
      parse_attributes(@result)
    end

    def routes(arg = nil)
      fetch_routes! unless routes_fetched?
      if arg.nil?
        @routes
      elsif arg.is_a?(Symbol)
        @routes.select do |search_hash, route|
          route.stations.include?(arg)
        end
      elsif arg.is_a?(Hash)
        direction = arg.keys.first
        station = arg.values.first
        routes = self.routes.values

        routes.select do |route|
          stations = direction == :to ? route.stations : route.stations.reverse
          if (station_index = stations.index(station)).nil?
            false
          else
            stations.index(self.abbr) < station_index
          end
        end
      end
    end

    def departures
      DepartureRequest.new(self)
    end

    def northbound_departures
      departures.north
    end

    def northbound_departures
      departures.south
    end

    private

    def fetch_routes!
      fetch! if fetch?

      @routes = @result.select {|k,v| k =~ /_routes/}.values.collect(&:values).flatten.collect(&:split).flatten.reject {|v| v == 'ROUTE'}.collect.collect(&:to_i).inject({}) do |memo, route_number|
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
