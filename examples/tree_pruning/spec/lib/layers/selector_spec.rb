# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Layers::Selector do
  include PeopleStats

  let(:json) { people_stats_json }

  it 'should get all 12 themes with out query' do
    expect(subject.call(json)[:json].size).to eq 12
  end

  it 'should lookup sub_themes' do
    # first `first` is for shrek chain, and the second one is for initial json, but looks aweful :(
    result = subject.call(json.deep_dup, sub_theme_ids: 1)[:json].first

    expect(result).to be_a Hash
    expect(result['id']).to eq 1
  end

  it 'should lookup categories' do
    result = subject.call(json.deep_dup, categorie_ids: 11)[:json].first['sub_themes'].first['categories'].first
    expect(result).to be_a Hash
    expect(result['id']).to eq 11
  end

  it 'should lookup indicators' do
    result = subject.call(json.deep_dup, indicator_ids: [1, 31, 32])[:json]

    expect(result.first['sub_themes'].first['categories'].first['indicators'].first['id']).to eq 1
    expect(result.last['sub_themes'].first['categories'].first['indicators'].map { |a| a['id'] }).to include(32, 31)
  end

  it 'should return status if nothing found' do
    result = subject.call(json.deep_dup, sub_theme_ids: 1984)
    expect(result).to be_a Hash
    expect(result).to include(status: :not_found)
  end
end
