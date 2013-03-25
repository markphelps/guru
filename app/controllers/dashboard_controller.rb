class DashboardController < ApplicationController
  def index
  end

  def visits
    render json: current_studio.visits.recent.group_by_day(:visit_date, format: "%m/%d/%y").count
  end

  def sources
    sources = []
    current_studio.sources.top_ten.each do |s|
      sources << [s.name, s.members_count] unless s.members_count == '0'
    end
    render json: sources
  end
end
