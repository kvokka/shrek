# frozen_string_literal: true

module Shrek
  module Simple
    class Layer1 < Layers
      def call(hash)
        hash[:foo] = 23
        @next_layer.call(hash)
      end
    end

    class Layer2 < Layers
      def call(hash)
        hash[:foo] ||= 0
        hash[:foo] += 42
        hash[:baz] = :value
        custom_option = { flag: true }
        @next_layer.call(hash, custom_option)
        hash[:after_execution] = :added
        [hash]
      end
    end

    class Layer3 < Layers
      def call(hash, **opt)
        hash[:bar] = :pass if opt[:flag]
        @next_layer.call(hash)
      end
    end

    RSpec.describe Runner do
      context 'hash1, hash2, hash3' do
        subject { Shrek[Layer1, Layer2, Layer3].call({}) }
        it { is_expected.to include(foo: 65, baz: :value, bar: :pass, after_execution: :added) }
        it { is_expected.to be_a Array }
      end

      context 'hash2, hash3' do
        subject { Shrek[Layer2, Layer3].call({}) }
        it { is_expected.to include(foo: 42, baz: :value, bar: :pass, after_execution: :added) }
        it { is_expected.to be_a Array }
      end

      context 'hash1, hash3' do
        subject { Shrek[Layer1, Layer3].call({}) }
        it { is_expected.to include(foo: 23) }
        it { is_expected.to_not include(baz: :value) }
        it { is_expected.to_not include(bar: :pass) }
        it { is_expected.to_not include(after_execution: :added) }
        it { is_expected.to be_a Array }
      end

      context 'hash2, hash3 with args' do
        subject { Shrek[Layer2, Layer3].call(foo: 57) }
        it { is_expected.to include(foo: 99, baz: :value, bar: :pass, after_execution: :added) }
        it { is_expected.to be_a Array }
      end

      context 'hash2, hash3 with own return self' do
        subject { Shrek[Layer1, Layer3, self_return: ->(a) { { preffix: a } }].call({}) }
        it { is_expected.to include(preffix: { foo: 23 }) }
        it { is_expected.to be_a Hash }
      end
    end
  end
end
