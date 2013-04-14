module Bart
  class Route
    attr_reader :abbr, :destination, :name, :number, :origin, :search_hash, :direction, :stations

    @aliases = {}
    @routes = {}

    class << self
      def new(attrs)
        attrs = { 'number' => attrs } if attrs.is_a?(Numeric)
        puts attrs.count
        [attrs['number'].to_i].inject(nil) do |memo, route_number|
          if @routes[route_number].nil?
            route = super(attrs)
            self[route_number] = route
            self[route.search_hash] = route_number
          else
            route = self[route_number]
          end
          route
        end
      end

      def [](arg)
        fetch! if fetch?
        if arg.is_a?(Hash)
          arg = @aliases[arg]
        end
        route = @routes[arg]
        route.fetch! if route.fetch?
        route
      end

      def all
        fetch! if fetch?
        self
      end

      def []=(arg, val)
        if arg.is_a?(Hash)
          @aliases[arg] = val
        else
          @routes[arg] = val
        end
      end

      private

      def fetch?(route_arg = nil)
        if @routes.empty?
          true
        elsif route_arg.nil?
          false
        else
          @routes[route_arg].fetch?
        end
      end

      def fetch!
        result = Bart::Request.get(:routes)
        result['root']['routes'].values[0].each do |route|
          new(route)
        end
      end
    end

    def initialize(attrs)
      @name = attrs['name']
      @abbr = attrs['abbr']
      @number = attrs['number'].to_i
      @origin, @destination = @abbr.split('-').collect { |abbr| abbr.downcase.to_sym }
      @search_hash = { @origin => @destination }
      self.class[@search_hash] = @number
      self.class[@number] = self
    end

    def fetch?
      @direction.nil?
    end

    def fetch!
      @result = Bart::Request.get(:route, { :route => @number })['root']['routes'].values.first
      @direction = @result['direction']
      @stations = @result['config'].values[0].collect(&:downcase).collect(&:to_sym)
      true
    end

    def [](segment_hash)
      fetch! if fetch?
      origin = segment_hash.keys[0]
      destination = segment_hash.values[0]
      if segment?(origin => destination)
        # @TODO: Return actual segment, or etd info for segment?
        segment_hash
      else
        nil
      end
    end

    def segment?(segment_hash)
      segment_origin = segment_hash.keys[0]
      segment_destination = segment_hash.values[0]
      result = @stations.inject(nil) do |memo, station|
        puts memo
        if memo.nil? && station == segment_origin
          memo = segment_origin
        elsif memo == segment_origin && station == segment_destination
          memo = { segment_origin => segment_destination }
        end
        memo
      end
      segment_hash == result
    end

    def departures
      DepartureRequest.new(self)
    end
  end
end
