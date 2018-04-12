# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Layers::ExternalFetcher do
  context 'retry' do
    it 'retries if a request fails' do
      times = 3
      allow(subject).to receive(:response) do
        raise 'Hiccup' if (times -= 1).positive?
        'THE_RESULT'
      end

      expect(subject.call.first).to eq('THE_RESULT')
    end

    it 'gives up after 3 retries' do
      times = 4
      allow(subject).to receive(:response) do
        raise 'Hiccup' if (times -= 1).positive?
        'Newer reach here'
      end
      expect(subject.call).to(include(status: :internal_server_error))
    end
  end

  it "act's as Shrek, pusing request result forward" do
    stub_request(:get, 'http://enter_real_uri_here.stub/')
      .to_return(status: 200, body: 'MyResult', headers: {})
    expect(subject.call.first).to eq 'MyResult'
  end
end
