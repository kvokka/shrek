# frozen_string_literal: true

module Shrek
  class Layers
    def initialize(next_layer_proc = nil)
      next_layer_proc ||= proc { |*a| a }
      @next_layer = next_layer_proc
    end

    def call(*)
      raise 'Layer subclasses must define #call'
    end

    private

    attr_reader :next_layer
  end
end
