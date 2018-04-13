# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatisticsProcessor do
  include PeopleStats

  let(:file) { people_stats }

  before do
    stub_request(:get, 'http://enter_real_uri_here.stub/').to_return(body: file)
  end

  it 'should return all collection' do
    expect(subject.call[:json].size).to eq 12
  end

  it 'should return filtered collection' do
    result = subject.call(indicator_ids: [1, 31, 32])[:json]

    expect(result.first['sub_themes'].first['categories'].first['indicators'].first['id']).to eq 1
    expect(result.last['sub_themes'].first['categories'].first['indicators'].map { |a| a['id'] }).to include(32, 31)
  end
end
