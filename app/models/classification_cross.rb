class ClassificationCross
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

  def initialize(limit, offset, features=nil)
    @features = features||Diabetic::FEATURES
    @attributes = @features.reject {|f| f.to_sym==:positive}

    @test_data_set = Diabetic.limit(limit).offset(offset)
    @training_data_set = Diabetic.excludes(@test_data_set.collect(&:id))
    @training = @training_data_set.collect {|d| @features.collect {|f| d.send(f)}}
  end

  def predictxx
    dec_tree = DecisionTree::ID3Tree.new(@attributes, @training, 1, :continuous)
    dec_tree.train
    sample ||= @training.first
    decision = dec_tree.predict(sample)

    return [{:sample => sample, :decision => decision, :actual => sample[8]}]
  end

  def predict
    results = []

    correctly_classified = 0
    incorrectly_classified = 0
    test_instances = @test_data_set.count
    training_instances = @training_data_set.count

    @test_data_set.each do |d|
      actual = d.positive
      sample = @features.collect {|f| d.send(f)}

      dec_tree = DecisionTree::ID3Tree.new(@attributes, @training, 1, :continuous)
      dec_tree.train

      decision = dec_tree.predict(sample)

      actual == decision.to_i ? correctly_classified +=1 : incorrectly_classified +=1

      results << {decision: decision.to_i, actual: actual, sample: sample}
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