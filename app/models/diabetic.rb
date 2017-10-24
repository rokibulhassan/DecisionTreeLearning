class Diabetic < ActiveRecord::Base

  attr_accessor :radius

  FEATURES = [:pregnant, :oral_glucose_tolerance, :blood_pressure, :skin_fold_thickness, :serum_insulin, :body_mass_index, :pedigree_function, :age, :positive]

  scope :positive, -> {where(positive: 1)}
  scope :negative, -> {where(positive: 0)}
  scope :excludes, ->(ids) {where('id not in(?)', ids)}
  if Rails.env.production?
    scope :pick, ->(n) {order("RANDOM()").limit(n)}
  else
    scope :pick, ->(n) {order("RAND()").limit(n)}
  end

  def self.import(file=nil)
    file_path = file.present? ? file.path : Rails.root.join("diabetic_data.csv")
    CSV.foreach(file_path, headers: true) do |row|
      attributes = row.to_hash
      Diabetic.create(attributes)
    end
  end
end
