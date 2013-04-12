module Bart
  class Route
    attr_accessor :abbr, :destination, :name, :number, :origin, :search_hash

    @aliases = {}
    @routes = {}

    class << self
      def new(attrs)
        [attrs[:number].to_i].inject(nil) do |memo, route_number|
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
        #route.fetch! if route.fetch?
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
        extract_routes(Bart::Request.get(:routes))
      end

      def extract_routes(ox)
        ox.locate('*/routes/route').each do |ox_element|
          route_number = ox_element.locate('number')[0].text.to_i
          from_ox(ox_element)
        end
      end

      def from_ox(ox_element)
        new(ox_element.nodes.inject({}) do |route, ox_child|
          route[ox_child.name.to_sym] = ox_child.text
          route
        end)
      end
    end

    def initialize(attrs)
      @name = attrs[:name]
      @abbr = attrs[:abbr]
      @number = attrs[:number].to_i
      @origin, @destination = @abbr.split('-').collect { |abbr| abbr.downcase.to_sym }
      @search_hash = { @origin => @destination }
      self.class[@search_hash] = @number
      self.class[@number] = self
    end
  end
end
