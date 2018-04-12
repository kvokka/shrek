# frozen_string_literal: true

class StatisticsProcessor
  include Shrek

  def call(*args)
    use_layers(::Layers::ExternalFetcher, ::Layers::Parser, ::Layers::Selector).call(*args)
  end
end
