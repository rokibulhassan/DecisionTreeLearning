class Simple
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

  # 6,148,72,35,0,33.6,0.627,50,1
  # training = [
  #     [6, 'pregnant'],
  #     [148, 'oral_glucose_tolerance'],
  #     [72, 'blood_pressure'],
  #     [35, 'skin_fold_thickness'],
  #     [0, 'serum_insulin'],
  #     [33.6, 'body_mass_index'],
  #     [0.627, 'pedigree_function'],
  #     [50, 'age'],
  #     [1, 'positive']
  # ]

  def initialize(key=nil, attributes=nil, training=nil)
    @key = key || 'oral_glucose_tolerance'
    @attributes = attributes || ['Diabetes']
    @training = training ||[
        [6, 'pregnant'],
        [148, 'oral_glucose_tolerance'],
        [72, 'blood_pressure'],
        [35, 'skin_fold_thickness'],
        [0, 'serum_insulin'],
        [33.6, 'body_mass_index'],
        [0.627, 'pedigree_function'],
        [50, 'age'],
        [1, 'positive']
    ]
  end

  def tree
    dec_tree = DecisionTree::ID3Tree.new(@attributes, @training, @key, :continuous)
    dec_tree.train
    rule_set = dec_tree.rule_set

    result = rule_set.rules.each { |r| r.accuracy(rule_set.train_data) }
    result.collect { |r| ap [r.conclusion, r.accuracy] }
  end
end