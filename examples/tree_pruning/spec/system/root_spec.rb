# frozen_string_literal: true

require 'rails_helper'

describe 'root', type: :system do
  include PeopleStats

  let(:file) { people_stats }

  before do
    driven_by :selenium_chrome_headless
    stub_request(:get, 'http://enter_real_uri_here.stub/').to_return(body: file)
  end

  it 'visit root' do
    get root_url
    assert_response :success
  end

  it 'not found' do
    get root_url, params: { sub_theme_ids: [1984] }
    assert_response :not_found
  end

  it 'find only one' do
    get root_url, params: { sub_theme_ids: [1] }
    assert_response :success
    expect(JSON.parse(response.body).map { |a| a['id'] }).to eq [1]
  end
end
