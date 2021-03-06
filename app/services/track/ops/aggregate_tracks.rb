# frozen_string_literal: true

class Track::Ops::AggregateTracks
  # EXPERIMENTAL

  class << self
    def execute(distance_epsilon_for_new_track:, time_epsilon_for_new_track:)
      # Sort by id != sort by created_at, because imported tracks may have any created_at
      newer_track = newest_track
      tracks_to_join = []
      other_tracks(newer_track.id).each do |older_track|
        close_tracks = close_tracks?(
          newer_track.points.order(created_at: :asc, id: :asc).first,
          older_track.points.order(created_at: :desc, id: :desc).first,
          distance_epsilon_for_new_track,
          time_epsilon_for_new_track
        )
        if close_tracks
          tracks_to_join.unshift(newer_track)
        else
          join_tracks(newer_track, tracks_to_join)
          tracks_to_join = []
        end
        newer_track = older_track
      end
    end

    private

    def newest_track
      Track.order(created_at: :desc).first
    end

    def other_tracks(track)
      Track.order(created_at: :desc).where.not(id: track.id)
    end

    def close_tracks?(newer_track_start_point, older_track_finish_point, distance_epsilon_for_new_track, time_epsilon_for_new_track)
      older_track_finish_point.distance_to(newer_track_start_point) <= distance_epsilon_for_new_track &&
        older_track_finish_point.time_diff(newer_track_start_point) <= time_epsilon_for_new_track
    end

    def join_tracks(first_track, other_tracks)
      other_tracks = Array.wrap(other_tracks)
      return if other_tracks.blank?

      Track.transaction do
        joined_ids = [first_track.id] + other_tracks.map(&:id)
        Rails.logger.info("Join tracks [#{joined_ids.join(' + ')}]")
        first_track.points += other_tracks.map(&:points).flatten(1)
        first_track.geojson_hq = nil
        first_track.geojson_lq = nil
        first_track.save!
        other_tracks.each(&:destroy!)
      end
    end
  end
end
