class Topic < ActiveRecord::Base
  has_ancestry

  validates :name, presence: true, 
                   ancestry_uniqueness: true

  validates :description, presence: true
end
