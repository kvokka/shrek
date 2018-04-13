# frozen_string_literal: true

class TreeController < ApplicationController
  def index
    render StatisticsProcessor.new.call(permitted_params.to_h.symbolize_keys)
  end

  private

  def permitted_params
    params.permit(sub_theme_ids: [], categorie_ids: [], indicator_ids: [])
  end
end
