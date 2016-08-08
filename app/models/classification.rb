class Classification
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
    @attributes = ['Number of times pregnant',
                   'Plasma glucose concentration a 2 hours in an oral glucose tolerance test',
                   'Diastolic blood pressure (mm Hg)',
                   'Triceps skin fold thickness (mm)',
                   '2-Hour serum insulin (mu U/ml)',
                   'Body mass index (weight in kg/(height in m)^2)',
                   'Diabetes pedigree function',
                   'Age (years)',
                   'Tested positive for Diabetes']

    @training = Diabetic.all.collect { |d| [d.pregnant,
                                            d.oral_glucose_tolerance,
                                            d.blood_pressure,
                                            d.skin_fold_thickness,
                                            d.serum_insulin,
                                            d.body_mass_index,
                                            d.pedigree_function,
                                            d.age,
                                            d.positive] }
  end

  def predict(sample=nil)
    dec_tree = DecisionTree::ID3Tree.new(@attributes, @training, 1, :discrete)
    dec_tree.train

    sample ||= @training.first
    decision = dec_tree.predict(sample)
    #puts "Sample: #{sample} ... [Predicted:Decision] [#{decision}:#{sample.last}] ... [Predicted==Decision] #{decision == sample.last}"
    return [{sample: sample, decision: decision}]
  end

  def random
    results = []
    10.times do
      results << predict([random_input, random_input, random_input, random_input, random_input, random_input, random_input, random_input, [1, 0].sample])
    end
    results.flatten!
  end

  def random_input (min=0.0, max=100.0)
    (rand * (max-min) + min).round(2)
  end

end