module Bart
  class Station < Fetchable
    attr_accessor :routes, :address, :city, :state, :latitude, :longitude, :abbr, :name

    @filename = 'stn.aspx'
    @cmd = 'stns'

    class << self
      def [](arg)
        if (station = objects[arg]).nil?
          station = Station.new(arg)
        else
          station.fetch!
        end
        station
      end

      def []=(arg, val)
        objects[arg] = val
      end

      def all
        fetch! if fetch?
        objects
      end

      def result
        @result ||= super['stations'].values[0]
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
      @filename = 'stn.aspx'
      @cmd = 'stninfo'

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

    def routes
      fetch_routes! unless routes_fetched?
      @routes
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

      @routes = @result.select {|k,v| k =~ /_routes/}.values.compact.collect(&:values).flatten.collect(&:split).flatten.reject {|v| v == 'ROUTE'}.collect.collect(&:to_i).inject({}) do |memo, route_number|
        route = Bart[route_number]
        key = route.origin == self.abbr ? {:to => route.destination} : {:from => route.origin}
        memo[key] = route
        memo
      end

      @routes.extend(RouteDatasetMethods)
      @routes.station = self
    end

    def routes_fetched?
      ! @routes.nil?
    end

    module RouteDatasetMethods
      def [](arg = nil)
        if arg.is_a?(Symbol)
          routes = self.select do |search_hash, route|
            route.stations.include?(arg)
          end.values
        elsif arg.is_a?(Hash)
          direction = arg.keys.first
          station = arg.values.first
          routes = self.values

          unless (result = super(arg)).nil?
            result
          else
            routes.select do |route|
              stations = direction == :to ? route.stations : route.stations.reverse
              if (station_index = stations.index(station)).nil?
                false
              else
                stations.index(@station.abbr) < station_index
              end
            end
          end
        end
      end

      def station=(station)
        @station = station
      end
    end
  end
end
