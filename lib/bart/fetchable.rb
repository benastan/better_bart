module Bart
  class Fetchable < Requestable
    module SharedMethods
      def result
        @result ||= super['root']
      end
    end

    class << self
      include SharedMethods

      def new(*args)
        klass = super
        klass.send(:extend, SharedMethods)
        self << klass
        klass
      end

      def <<(klass)
        objects[klass.abbr.downcase.to_sym] = klass
      end

      def fetch?
        objects.empty?
      end

      def fetch!
        result.each { |object| new(object) }
      end

      def objects
        @objects ||= {}
      end
    end
  end
end
