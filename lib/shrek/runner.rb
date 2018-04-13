# frozen_string_literal: true

module Shrek
  class Runner
    attr_reader :layers, :options

    def initialize(*layers, **options)
      @options = options
      parse_layers!(*layers)
    end

    def call(*args)
      chain.call(*args)
    end

    private

    def chain
      layers.reverse.inject(self_return) { |inner, outer| outer.new(inner) }
    end

    def parse_layers!(*layers)
      # now we use all args as layers, but in future maybe will be convenient
      # to add registry?
      @layers = layers
    end

    def self_return
      options[:self_return] || EMPTY_RETURN
    end
  end
end
