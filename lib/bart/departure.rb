module Bart
  class DepartureRequest
    attr_accessor :origin, :direction, :platform, :departures

    def initialize(arg)
      if arg.is_a?(Bart::Station)
        @origin = arg
      elsif arg.is_a?(Bart::Route)
        @origin = Bart[arg.origin]
        @route = arg
        @route.fetch! if @route.fetch?
      elsif arg.is_a?(Hash)
      else
        throw ArgumentError.new
      end
    end

    def north
      @direction = 'n'
      self
    end

    def south
      @direction = 's'
      self
    end

    def results
      parse_ox(Bart::Request.get(:etd, params))
    end

    private

    def params
      {:orig => @origin.abbr, :direction => @direction, :platform => @platform}
    end
  end
end
