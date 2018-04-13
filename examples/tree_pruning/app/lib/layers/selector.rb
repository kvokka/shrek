# frozen_string_literal: true

module Layers
  module NestedHashFilter
    refine Hash do
      def fetch_for(wanted_key, wanted_ids)
        fetch(wanted_key.to_s, []).delete_if do |wanted|
          next if Array(wanted_ids).map(&:to_i).include? wanted.fetch('id') { raise JSON::ParserError }
          block_given? ? yield(wanted) : true
        end.empty?
      end

      def proceed(**args)
        return fetch_for(*args.shift) if args.keys.one?
        fetch_for(*args.shift) { |wrap| wrap.proceed(args) if args.any? }
      end
    end
  end

  using Layers::NestedHashFilter

  class NotFound < StandardError; end

  class Selector < Shrek::Layers
    def call(data, sub_theme_ids: nil, categorie_ids: nil, indicator_ids: nil, **_options)
      return { json: data } if Array(sub_theme_ids).empty? &&
                               Array(categorie_ids).empty? &&
                               Array(indicator_ids).empty? && data.any?

      result = data.delete_if do |w|
        w.proceed(sub_themes: sub_theme_ids, categories: categorie_ids, indicators: indicator_ids)
      end

      raise(NotFound) if result.empty?
      { json: result }
    rescue NotFound
      not_found
    end

    private

    def not_found
      { json: '', status: :not_found }
    end
  end
end
