# frozen_string_literal: true

module Shrek
  class Layers
    def initialize(next_layer_proc = nil)
      next_layer_proc ||= EMPTY_RETURN
      @next_layer = next_layer_proc
    end

    def call(*)
      raise 'Layer subclasses must define #call'
    end

    def skip!(count = 1)
      raise ArgumentError unless count.is_a?(Integer) || count <= 0
      count.times.inject(self) { |acc, _| acc.next_layer }
    end

    def skip(count = 1)
      skip! count
    rescue NoMethodError => _error
      EMPTY_RETURN
    end

    protected

    attr_reader :next_layer
  end
end
