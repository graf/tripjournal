class MapController < ApplicationController
  def index
    @current_position = Point.last || Note.where('latlng is not null').last || Point.new(lat: 53.1958769, lng: 50.1283811)
  end
end
