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
      layers.reverse.inject(EMPTY_RETURN) { |inner, outer| outer.new(inner) }
    end

    def parse_layers!(*layers)
      # now we use all args as layers, but in future maybe will be convenient
      # to add registry?
      @layers = layers
    end
  end
end
