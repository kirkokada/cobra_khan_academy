class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name_with_ancestry, use: [:slugged, :finders]
  attr_accessor :position
  has_many :instructionals
  has_ancestry orphan_strategy: :rootify

  validates :name, presence: true, 
                   ancestry_uniqueness: true

  validates :description, presence: true

  private

  # Creates a string using the names of ancestors for use as a slug
  def name_with_ancestry
    names = []
    self.ancestors.each { |ancestor| names << ancestor.name }
    names << self.name
    names.join(" ")
  end
end
