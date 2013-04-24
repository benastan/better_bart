require 'bart/route'
require 'bart/station'
require 'bart/departure'

module Bart
  class << self
    def [](arg)
      case arg
      when String
        Bart::Station[arg.to_sym]
      when Symbol
        Bart::Station[arg]
      when Hash
      when Numeric
        Bart::Route[arg]
      end
    end
  end
end
