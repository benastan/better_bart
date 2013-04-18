module Bart
  class Station < Fetchable
    attr_accessor :routes, :address, :city, :state, :latitude, :longitude, :abbr, :name

    @filename = 'stn.aspx'
    @cmd = 'stns'
    @fetchall = true

    class << self
      def new(arg)
        klass = super
        klass.send(:extend, InstanceMethods)
        if arg.is_a?(String) || arg.is_a?(Symbol)
          klass.fetch!
        end
        klass
      end

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

      def fetch?
        @fetchall === true
      end

      def fetch!
        @fetchall = false
        super
      end
    end

    def initialize(arg)
      @filename = 'stn.aspx'
      @cmd = 'stninfo'

      if arg.is_a?(Hash)
        parse_attributes(arg)
      elsif arg.is_a?(String)
        @abbr = arg.to_sym
      elsif arg.is_a?(Symbol)
        @abbr = arg
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

    module InstanceMethods
      def fetch?
        @routes.nil?
      end

      def params
        super.merge(orig: @abbr)
      end

      def result
        @result ||= super['stations'].values.first
      end

      def fetch!
        parse_attributes(result)
      end

      def routes
        fetch_routes! unless routes_fetched?
        @routes
      end

      def departures(arg = nil)
        @departures = Bart::Departure.from(@abbr)
        arg.nil? ? @departures : @departures[arg]
      end

      private

      def fetch_routes!
        fetch! if fetch?

        @routes = @result.select {|k,v| k =~ /_routes/}.values.compact.collect(&:values).flatten.collect(&:split).flatten.reject {|v| v == 'ROUTE'}.collect.collect(&:to_i).collect do |route_number|
          route = Bart[route_number]
        end

        @routes.extend(RouteDatasetMethods)
        @routes.station = self
      end

      def routes_fetched?
        ! @routes.nil?
      end
    end

    module RouteDatasetMethods
      def [](arg)
        if arg.is_a?(Symbol)
          routes = self.select do |route|
            route.stations.include?(arg)
          end
        elsif arg.is_a?(Hash)
          direction = arg.keys.first
          station = arg.values.first
          routes = self

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

      def station=(station)
        @station = station
      end
    end
  end
end
