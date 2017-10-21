class KnnNumericalCross
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

  def initialize(limit=77, offset=0)
    @test_data_set = Diabetic.limit(limit).offset(offset)
    @training_data_set = Diabetic.excludes(@test_data_set.collect(&:id))

    @training = @training_data_set.collect {|d| [d.pregnant,
                                                 d.oral_glucose_tolerance,
                                                 d.blood_pressure,
                                                 d.skin_fold_thickness,
                                                 d.serum_insulin,
                                                 d.body_mass_index,
                                                 d.pedigree_function,
                                                 d.age,
                                                 d.positive]}

    @knn = KNN.new(@training)
  end

  def predict(k=7)
    results = []

    correctly_classified = 0
    incorrectly_classified = 0
    test_instances = @test_data_set.count
    training_instances = @training_data_set.count

    @test_data_set.each do |d|
      actual = d.positive
      sample = [d.pregnant, d.oral_glucose_tolerance, d.blood_pressure, d.skin_fold_thickness, d.serum_insulin, d.body_mass_index, d.pedigree_function, d.age, d.positive]

      distances = @knn.nearest_neighbours(sample, k)

      data_points = distances.collect {|d| d[2]}
      positive = data_points.select {|d| d[8] == 1}.count
      negative = data_points.select {|d| d[8] == 0}.count
      decision = positive >= negative ? 1 : 0

      actual == decision ? correctly_classified +=1 : incorrectly_classified +=1

      results << {decision: decision, actual: actual, sample: sample, distances: distances}
    end

    accuracy = ((correctly_classified.to_f/@test_data_set.count)*100).round(2)
    inaccuracy = ((incorrectly_classified.to_f/@test_data_set.count)*100).round(2)

    {training_instances: training_instances,
     test_instances: test_instances,
     correctly_classified: correctly_classified,
     incorrectly_classified: incorrectly_classified,
     accuracy: accuracy,
     inaccuracy: inaccuracy,
     data: results}
  end

end