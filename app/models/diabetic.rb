class Diabetic < ActiveRecord::Base

  attr_accessor :radios

  scope :positive, -> { where(positive: 1) }
  scope :negative, -> { where(positive: 0) }

  def self.import(file=nil)
    file_path = file.present? ? file.path : Rails.root.join("diabetic_data.csv")
    CSV.foreach(file_path, headers: true) do |row|
      attributes = row.to_hash
      Diabetic.create(attributes)
    end
  end
end
