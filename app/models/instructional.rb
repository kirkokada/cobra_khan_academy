class Instructional < ActiveRecord::Base
  extend FriendlyId
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name "cka-instructionals-#{Rails.env}"

  friendly_id :title, use: [:slugged, :finders]

  belongs_to :topic

  VALID_URL_REGEX = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*\z/i

  validates :url, presence: true,
                  format: { with: VALID_URL_REGEX }

  before_validation :get_uid_from_url
  before_validation :get_additional_info

  scope :recent, -> { order("created_at DESC") }

  # Elastic search settings
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :title, type: "multi_field" do
        indexes :title, analyzer: 'snowball'
        indexes :tokenized, analyzer: 'simple'
      end
      indexes :description, type: "multi_field" do
        indexes :description, analyzer: "snowball"
        indexes :tokenized, analyzer: 'simple'
      end
    end
  end

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

  # Elastic Search method

  def self.search(query)
    __elasticsearch__.search(
    {
      query: {
        multi_match: {
          query: query,
          fields: ['title^10', 'description']
        }
      },
      highlight: {
        pre_tags: ['<highlight>'],
        post_tags: ['</highlight>'],
        fields: {
          title: {},
          description: {}
        }
      }
    }
      )
  end


  private

  def get_uid_from_url
    matches = url.match(VALID_URL_REGEX)
    self.uid = matches[2] if matches && matches[2]
  end

  def get_video
    client = YouTubeIt::Client.new(dev_key: ENV["google_api_key"])
    if uid.present?
      begin
        client.video_by(uid)
      rescue OpenURI::HTTPError => error
        self.errors.add(:url)
        nil
      end
    else
      nil
    end
  end

  def get_additional_info
    unless video.nil?
      self.title = video.title             if self.title.blank?
      self.slug = title.parameterize
      self.description = video.description if self.description.blank?
      self.author = video.author.name
      self.duration = video.duration
    end
  end
end

Instructional.import # for auto-sync with Elastic Search
