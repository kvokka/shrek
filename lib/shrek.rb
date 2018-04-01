# frozen_string_literal: true

require 'shrek/version'
require 'shrek/runner'
require 'shrek/layers'

module Shrek
  EMPTY_RETURN = proc { |*a| a }

  module_function

  def use_layers(*args)
    Runner.new(*args)
  end

  singleton_class.alias_method :[], :use_layers
end
