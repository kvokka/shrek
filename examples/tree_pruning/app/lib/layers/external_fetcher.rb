# frozen_string_literal: true

require 'net/http'
module Layers
  class ExternalFetcher < Shrek::Layers
    def call(uri: 'enter_real_uri_here.stub', path: '/', tries: 3, **options)
      next_layer.call(response(uri, path), options)
    rescue StandardError => e
      tries -= 1
      retry if tries.positive?
      { json: e.message, status: :internal_server_error }
    end

    private

    def response(uri, path)
      Net::HTTP.get_response(uri, path).body
      # open(Rails.root.join('spec', 'fixtures', 'files', 'people_stats.json')).read
    end
  end
end
