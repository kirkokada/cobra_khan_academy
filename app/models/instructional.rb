class Instructional < ActiveRecord::Base
  belongs_to :topic

  VALID_URL_REGEX = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*\z/i

  validates :url, presence: true,
                  format: { with: VALID_URL_REGEX }
  validates :uid, presence: true, 
                  length: { is: 11 }, 
                  uniqueness: true

  before_validation :get_uid_from_url
  before_create :get_additional_info


  def video
    @video ||= get_video
  end

  def embed_html5_video(options={})
    video.embed_html5(options)
  end

  def author_url
    "https://youtube.com/user/" + self.author
  end

  def thumbnail
    "http://img.youtube.com/vi/#{uid}/default.jpg"
  end

  private

  def get_uid_from_url
    uid = url.match(VALID_URL_REGEX)
    self.uid = uid[2] if uid && uid[2]
  end

  def get_video
    client = YouTubeIt::Client.new(dev_key: ENV["google_api_key"])
    client.video_by(uid)
  end

  def get_additional_info
    self.title = video.title             if self.title.blank?
    self.description = video.description if self.description.blank?
    self.author = video.author.name
    self.duration = parse_duration(video.duration)
  end

  def parse_duration(duration)
    hours = (duration / 3600).floor
    minutes = (duration - (hours * 3600) / 60).floor
    seconds = (duration - (hours * 3600) - (minutes * 60)).floor
    hours = "0" + hours.to_s if hours.to_i < 10
    minutes = "0" + minutes.to_s if minutes.to_i < 10
    seconds = "0" + seconds.to_s if seconds.to_i < 10

    hours.to_s + ":" + minutes.to_s + ":" + seconds.to_s
  end
end
