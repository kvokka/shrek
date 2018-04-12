# frozen_string_literal: true

module PeopleStats
  def people_stats
    path = Rails.root.join('spec', 'fixtures', 'files', 'people_stats.json')
    @people_stats ||= File.open(path).read.freeze
  end

  def people_stats_json
    @people_stats_json ||= people_stats.to_json.freeze
  end
end
