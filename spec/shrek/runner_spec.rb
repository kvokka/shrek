# frozen_string_literal: true

module Shrek
  class SimpleLayer < Layers
    def call(*)
      42
    end
  end

  RSpec.describe Runner do
    context 'Simple layer structure' do
      it 'Execute runner on #call method' do
        expect(Shrek[SimpleLayer].call).to eq(42)
      end

      it 'Chain return chained collection' do
        expect(Shrek[SimpleLayer].send(:chain)).to be_a(SimpleLayer)
      end
    end
  end
end
