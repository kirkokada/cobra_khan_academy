class Discipline < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true

  before_save :downcase_name

  private 
    def downcase_name
      name.downcase!
    end
end
