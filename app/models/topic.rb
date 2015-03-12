class Topic < ActiveRecord::Base
  belongs_to :parent, class_name: "Topic", foreign_key: "parent_id"
  has_many :subtopics, class_name: "Topic", foreign_key: "parent_id"

  validates :name, presence: true, 
                   uniqueness: { scope: :parent, case_sensitive: false}

  validates :description, presence: true

  scope :top_level, -> { where(parent: nil) }

  delegate :name, to: :parent, prefix: true

  def top_level?
    parent.nil?    
  end
end
