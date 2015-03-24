require 'csv'
class CSVImporter
  include ActiveModel::Model

  attr_accessor :file, :model_name

  def initialize(attributes={})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_objects.map(&:valid?).all?
      imported_objects.each(&:save!)
      true
    else
      imported_objects.each_with_index do |object, index|
        object.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2} : #{message}"
        end
      end
      false
    end
  end

  def target_model
    model_name.classify.constantize
  end

  def imported_objects
    @imported_objects ||= load_imported_objects(file)
  end

  def load_imported_objects(csv_file)
    objects = []
    CSV.foreach(csv_file.path, headers: true) do |row|
      row = row.to_hash
      new_object = target_model.find_by_id(row['id']) || target_model.new
      row.each do |key, value|
        new_object.send("#{key}=", value)
      end
      objects << new_object
    end
    objects
  end
end