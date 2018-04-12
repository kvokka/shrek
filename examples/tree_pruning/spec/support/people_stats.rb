# frozen_string_literal: true

require 'json'
require 'ice_nine/core_ext/object'

module PeopleStats
  def people_stats
    path = Rails.root.join('spec', 'fixtures', 'files', 'people_stats.json')
    @people_stats ||= File.open(path).read.deep_freeze
  end

  def people_stats_json
    @people_stats_json ||= JSON.parse(people_stats).deep_freeze
  end
end
