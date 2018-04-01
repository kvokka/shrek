# frozen_string_literal: true

module Shrek
  module WithRescue
    class Layer1 < Layers
      def call(hash)
        hash[:foo] = 23
        @next_layer.call(hash)
      rescue ArgumentError => error
        hash[:error] = error
        count = hash.fetch :count, 1
        @next_layer.skip(count).call hash
      end
    end

    class Layer2 < Layers
      def call(hash)
        hash[:baz] = :value
        raise ArgumentError
      end
    end

    class Layer3 < Layers
      def call(hash)
        hash[:bar] = :pass
        @next_layer.call(hash)
      end
    end

    class SkippedLayer1 < Layers
      def call(hash)
        hash[:skip1] = :must_skip_it
        @next_layer.call(hash)
      end
    end

    class SkippedLayer2 < Layers
      def call(hash)
        hash[:skip2] = :must_skip_it
        @next_layer.call(hash)
      end
    end

    RSpec.describe Runner do
      context 'layer1, rescue layer2, layer3' do
        subject { Shrek[Layer1, Layer2, Layer3].call({}).first }

        it { is_expected.to include(foo: 23, baz: :value, bar: :pass) }
      end

      context 'layer1, rescue layer2, skip1, skip2, layer3' do
        subject { Shrek[Layer1, Layer2, SkippedLayer1, SkippedLayer2, Layer3].call(count: count).first }

        context 'skip 5' do
          let(:count) { 5 }
          it { is_expected.to include(foo: 23, baz: :value) }
          it { is_expected.to_not have_key(:skip1) }
          it { is_expected.to_not have_key(:skip2) }
        end

        context 'skip 4' do
          let(:count) { 4 }
          it { is_expected.to include(foo: 23, baz: :value) }
          it { is_expected.to_not have_key(:bar) }
          it { is_expected.to_not have_key(:skip1) }
          it { is_expected.to_not have_key(:skip2) }
        end

        context 'skip 3' do
          let(:count) { 3 }
          it { is_expected.to include(foo: 23, baz: :value, bar: :pass) }
          it { is_expected.to_not have_key(:skip1) }
          it { is_expected.to_not have_key(:skip2) }
        end

        context 'skip 2' do
          let(:count) { 2 }
          it { is_expected.to include(foo: 23, baz: :value, bar: :pass) }
          it { is_expected.to_not have_key(:skip1) }
          it { is_expected.to have_key(:skip2) }
        end
      end
    end
  end
end
