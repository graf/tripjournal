class MapController < ApplicationController

  def index
    @center = current_center_point
  end

  private

  def current_center_point
    Point.order(created_at: :desc).first ||
    Note.where('lat is not null').where('lng is not null').order(created_at: :desc).first ||
    Point.new(lat: 53.1958769, lng: 50.1283811)
  end

end
