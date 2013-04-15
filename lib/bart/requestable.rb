require 'faraday'
require 'multi_xml'

MultiXml.parser = :ox

module Bart
  class Requestable
    API_KEY = 'EMH2-BJSB-ITEQ-95MP'
    HOSTNAME = 'api.bart.gov'

    module SharedMethods
      def url
        File.join('http://', HOSTNAME, 'api', @filename)
      end

      def params
        {:key => API_KEY, :cmd => @cmd}
      end

      def query
        params.collect do |k, v|
          v.nil? ? nil : "#{k.to_s}=#{URI.escape(v.to_s)}"
        end.compact.join('&')
      end

      def result
        MultiXml.parse(Faraday.get("#{url}?#{query}").body)
      end
    end

    class << self
      include SharedMethods

      def new(*args)
        klass = super
        klass.send(:extend, SharedMethods)
        klass
      end
    end
  end
end
