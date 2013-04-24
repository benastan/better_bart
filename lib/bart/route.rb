require 'bart/fetchable'
require 'bart/station'

module Bart
  class Route < Fetchable
    attr_reader :abbr, :destination, :name, :number, :origin, :search_hash, :direction, :stations

    @aliases = {}
    @filename = 'route.aspx'
    @cmd = 'routes'

    class << self
      def <<(klass)
        objects[klass.number] = klass
        @aliases[klass.search_hash] = klass.number
      end

      def new(attrs)
        attrs = { 'number' => attrs } if attrs.is_a?(Numeric)
        route = [attrs['number'].to_i].inject(nil) do |memo, route_number|
          if objects[route_number].nil?
            route = super(attrs)
          else
            route = self[route_number]
          end
          route
        end
        route.send(:extend, InstanceMethods)
        route
      end

      def [](arg)
        fetch! if fetch?
        if arg.is_a?(Hash)
          arg = @aliases[arg]
        end
        route = objects[arg]
        route.fetch! if route.fetch?
        route
      end

      def all
        fetch! if fetch?
        objects
      end

      def []=(arg, val)
        if arg.is_a?(Hash)
          @aliases[arg] = val
        else
          objects[arg] = val
        end
      end

      def result
        @result ||= super['routes'].values[0]
      end

      private

      def fetch?(route_arg = nil)
        if super()
          true
        elsif route_arg.nil?
          false
        else
          objects[route_arg].fetch?
        end
      end
    end

    def initialize(attrs)
      @cmd = 'routeinfo'
      @filename = 'route.aspx'

      @name = attrs['name']
      @abbr = attrs['abbr']
      @number = attrs['number'].to_i
      @origin, @destination = @abbr.split('-').collect { |abbr| abbr.downcase.to_sym }
      @search_hash = { @origin => @destination }
    end

    module InstanceMethods
      def fetch?
        @direction.nil?
      end

      def params
        super.merge(route: @number)
      end

      def result
        @result ||= super['routes'].values.first
      end

      def fetch!
        @direction = result['direction']
        @stations = result['config'].values[0].collect(&:downcase).collect(&:to_sym)
        true
      end
    end
  end
end
