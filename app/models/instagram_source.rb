class InstagramSource < ApplicationRecord

  def init!
    last_photo = client.user_recent_media(self.user_id, count: 1).first
    self.update_attribute(:last_media_id, last_photo.id)
  end

  def sync!
    photos = client.user_recent_media(self.user_id, min_id: self.last_media_id)
    return if photos.empty?

    photos.each { |p| create_note(p) }
    self.update_attribute(:last_media_id, photos.first.id)
  end

  private

  def client
    @client ||= Instagram.client(access_token: ENV['INSTAGRAM_ACCESS_TOKEN'])
  end

  def create_note(photo)
    Note.find_or_create_by(source_id: photo.id) do |note|
      note.kind = :photo
      note.title = photo.caption.try(:text)
      note.image_url = photo.images.standard_resolution.url
      note.source_id = photo.id
      note.source_url = photo.link
      note.author = photo.user.username
      note.created_at = Time.at(photo.created_time.to_i)
      if photo.location.present? && photo.location.latitude.present? && photo.location.longitude.present?
        note.lat = photo.location.latitude
        note.lng = photo.location.longitude
      end
    end
  end
end
