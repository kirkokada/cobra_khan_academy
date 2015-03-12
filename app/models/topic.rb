class Topic < ActiveRecord::Base
  belongs_to :parent, class_name: "Topic", foreign_key: "parent_id"
  has_many :subtopics, class_name: "Topic", foreign_key: "parent_id"

  validates :name, presence: true, 
                   uniqueness: { scope: :parent, case_sensitive: false}
end
