class KnnNumerical
  # Attributes
  # 1. pregnant -> Number of times pregnant
  # 2. oral_glucose_tolerance -> Plasma glucose concentration a 2 hours in an oral glucose tolerance test
  # 3. blood_pressure -> Diastolic blood pressure (mm Hg)
  # 4. skin_fold_thickness -> Triceps skin fold thickness (mm)
  # 5. serum_insulin -> 2-Hour serum insulin (mu U/ml)
  # 6. body_mass_index -> Body mass index (weight in kg/(height in m)^2)
  # 7. diabetes_pedigree_function -> Diabetes pedigree function
  # 8. age -> Age (years)
  # 9. tested_positive -> Class variable (0 or 1)

  def initialize
    @training = Diabetic.pick(460).collect { |d| [d.pregnant,
                                                   d.oral_glucose_tolerance,
                                                   d.blood_pressure,
                                                   d.skin_fold_thickness,
                                                   d.serum_insulin,
                                                   d.body_mass_index,
                                                   d.pedigree_function,
                                                   d.age,
                                                   d.positive] }

    @knn = KNN.new(@training)
  end

  def predict(sample=nil, k=7)
    k = 7 if k==0
    sample ||= @training.first
    distances = @knn.nearest_neighbours(sample, k)

    data_points = distances.collect { |d| d[2] }
    positive = data_points.select { |d| d[8] == 1 }.count
    negative = data_points.select { |d| d[8] == 0 }.count
    decision = positive >= negative ? 1 : 0

    return [{:sample => sample, :distances => distances, :decision => decision, :actual => sample[8]}]
  end

  def random
    results = []
    Diabetic.pick(308).each do |d|
      results << predict([d.pregnant, d.oral_glucose_tolerance, d.blood_pressure, d.skin_fold_thickness, d.serum_insulin, d.body_mass_index, d.pedigree_function, d.age, d.positive])
    end
    results.flatten!
  end

  def random_input (min=0.0, max=100.0)
    (rand * (max-min) + min).round(2)
  end

end