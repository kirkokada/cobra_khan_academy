class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name_with_ancestry, use: [:slugged, :finders]
  attr_accessor :position, :temp_parent_id
  has_many :instructionals
  has_ancestry orphan_strategy: :rootify

  validates :name, presence: true, 
                   ancestry_uniqueness: true

  validates :description, presence: true

  after_update :update_child_slugs

  before_save :check_for_parent

  # Returns a string with the names of all ancestors for use as the slug.

  def name_with_ancestry
    names = ancestor_names
    names << self.name
    names.join(" > ")
  end

  def ancestor_names
    names = []
    self.ancestors.each { |ancestor| names << ancestor.name }
    names
  end

  def subtopics
    self.children
  end

  def subtopics_by_priority
    subtopics.order('priority asc')
  end

  # Returns instructionals belonging to self and to descendants
  
  def descendant_instructionals
    Instructional.where("topic_id IN (:descendant_ids) OR topic_id = :id", descendant_ids: descendant_ids, id: id)
  end

  def parent_id= parent_id
    begin
      super
    rescue
      self.temp_parent_id = parent_id
    end
  end

  private

  # Creates a string using the names of ancestors for use as a slug

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def update_child_slugs
    self.children.all.each do |child|
      child.update_attribute(:slug, child.name_with_ancestry.parameterize)
    end
  end

  def check_for_parent
    if temp_parent_id
      self.parent = unscoped_find(temp_parent_id)
      self.slug = name_with_ancestry.parameterize
    end
  end
end