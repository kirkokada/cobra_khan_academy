class Topic < ActiveRecord::Base
  attr_accessor :position
  has_ancestry orphan_strategy: :rootify

  validates :name, presence: true, 
                   ancestry_uniqueness: true

  validates :description, presence: true
end
