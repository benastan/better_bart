require 'bart/requestable'
require 'bart/station'

module Bart
  class Departure < Requestable
    attr_accessor :bikes, :origin, :destination, :direction, :cars, :minutes, :platform

    @filename = 'etd.aspx'
    @cmd = 'etd'

    class << self
      def from(station, platform = nil, direction = nil)
        @direction = direction unless direction.nil?
        @platform = platform unless platform.nil?
        @station = station
        @request = true
        fetch!
        objects
      end

      def objects
        @objects
      end

      def fetch!
        @result = nil
        @objects = result.collect do |group|
          abbr = group['abbreviation'].downcase.to_sym
          [group['estimate']].flatten.collect do |attrs|
            attrs['destination'] = abbr
            attrs['origin'] = @station
            new(attrs)
          end
        end.flatten
        @objects.send(:extend, DatasetMethods)
        nil
      end

      def params
        params = { orig: @station }
        params[:plat] = @platform unless @platform.nil?
        params[:dir] = @direction unless @direction.nil?
        super.merge(params)
      end

      def result
        @result ||= begin
                      result = super['root']['station']['etd']
                      result.is_a?(Array) ? result : [result]
                    end
      end
    end

    def initialize(attrs)
      @minutes = attrs['minutes'].to_i
      @bikes = attrs['bikeflag'] === "1"
      @cars = attrs['length'].to_i
      @platform = attrs['platform'].to_i
      @direction = attrs['direction'].downcase.to_sym
      @origin = attrs['origin']
      @destination = attrs['destination']
    end

    def route
      @route ||= Bart[@origin].routes[:to => @destination].first
    end

    def northbound?
      @direction === :north
    end

    def southbound?
      @direction === :south
    end

    module DatasetMethods
      def [](arg)
        if arg.is_a?(Numeric)
          super(arg)
        elsif arg.is_a?(Symbol)
          dataset(self.select do |departure|
            stations = departure.route.stations
            stations.include?(arg) && (stations.index(departure.origin) < stations.index(arg))
          end)
        else
          # @TODO: Throw ArgumentError
        end
      end

      def to(other_station)
        self[other_station]
      end

      def estimates
        collect(&:minutes).sort
      end

      def northbound
        dataset(select(&:northbound?))
      end

      def southbound
        dataset(select(&:southbound?))
      end

      def platform(platform)
        dataset(select { |departure| departure.platform === platform })
      end

      private

      def dataset(ary)
        ary.send(:extend, DatasetMethods)
        ary
      end
    end
  end
end
