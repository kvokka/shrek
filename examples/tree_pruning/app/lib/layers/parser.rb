# frozen_string_literal: true

module Layers
  class Parser < Shrek::Layers
    def call(body = '', **options)
      next_layer.call JSON.parse(body), options
    rescue JSON::ParserError
      { status: :unprocessable_entity }
    end
  end
end
