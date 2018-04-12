# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Layers::Parser do
  include PeopleStats

  let(:file) { people_stats }

  it 'should parse valid json' do
    expect(subject.call(file)).to be_truthy
  end

  it 'should not parse invalid json' do
    expect(subject.call('{invalid: json:[}')).to include(status: :unprocessable_entity)
  end
end
