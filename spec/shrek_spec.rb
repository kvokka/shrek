# frozen_string_literal: true

RSpec.describe Shrek do
  class TestLayer; end

  it 'has a version number' do
    expect(Shrek::VERSION).not_to be nil
  end

  it 'Generate runner on ::[] method' do
    expect(Shrek[TestLayer]).to be_a(Shrek::Runner)
  end
end
