# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Layers::Parser do
  let(:file) { File.open(Rails.root.join('spec', 'fixtures', 'files', 'people_stats.json')).read }

  it 'should parse valid json' do
    expect(subject.call(file)).to be_truthy
  end

  it 'should not parse invalid json' do
    expect(subject.call('{invalid: json:[}')).to include(status: :unprocessable_entity)
  end
end
