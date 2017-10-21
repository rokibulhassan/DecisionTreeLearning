class SvmCross
  require 'libsvm'
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

  #### SVM Parameters
  #1. labels -> result/positive/negative (0 or 1)
  #2. examples -> training data without result

  def initialize(kernel_type='RBF', limit, offset)
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


    @problem = Libsvm::Problem.new
    @parameter = Libsvm::SvmParameter.new
    @parameter.kernel_type = "Libsvm::KernelType::#{kernel_type}".constantize
    @parameter.cache_size = 100 # in megabytes
    @parameter.eps = 0.001
    @parameter.c = 10


    @labels = @training.collect {|t| t.pop}
    @examples = @training.map {|ary| Libsvm::Node.features(ary)}


    @problem.set_examples(@labels, @examples)

    @svm = Libsvm::Model.train(@problem, @parameter)
  end

  def predict
    results = []

    correctly_classified = 0
    incorrectly_classified = 0
    test_instances = @test_data_set.count
    training_instances = @training_data_set.count

    @test_data_set.each do |d|
      actual = d.positive
      sample = [d.pregnant, d.oral_glucose_tolerance, d.blood_pressure, d.skin_fold_thickness, d.serum_insulin, d.body_mass_index, d.pedigree_function, d.age, d.positive]
      sample.pop

      decision = @svm.predict(Libsvm::Node.features(sample))

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

# class KnnNumericalCross
#   # Attributes
#   # 1. pregnant -> Number of times pregnant
#   # 2. oral_glucose_tolerance -> Plasma glucose concentration a 2 hours in an oral glucose tolerance test
#   # 3. blood_pressure -> Diastolic blood pressure (mm Hg)
#   # 4. skin_fold_thickness -> Triceps skin fold thickness (mm)
#   # 5. serum_insulin -> 2-Hour serum insulin (mu U/ml)
#   # 6. body_mass_index -> Body mass index (weight in kg/(height in m)^2)
#   # 7. diabetes_pedigree_function -> Diabetes pedigree function
#   # 8. age -> Age (years)
#   # 9. tested_positive -> Class variable (0 or 1)
#
#   def initialize(limit=77, offset=0)
#     @test_data_set = Diabetic.limit(limit).offset(offset)
#     @training_data_set = Diabetic.excludes(@test_data_set.collect(&:id))
#
#     @training = @training_data_set.collect {|d| [d.pregnant,
#                                                  d.oral_glucose_tolerance,
#                                                  d.blood_pressure,
#                                                  d.skin_fold_thickness,
#                                                  d.serum_insulin,
#                                                  d.body_mass_index,
#                                                  d.pedigree_function,
#                                                  d.age,
#                                                  d.positive]}
#
#     @knn = KNN.new(@training)
#   end
#
#   def predict(k=7)
#     results = []
#
#     correctly_classified = 0
#     incorrectly_classified = 0
#     test_instances = @test_data_set.count
#     training_instances = @training_data_set.count
#
#     @test_data_set.each do |d|
#       actual = d.positive
#       sample = [d.pregnant, d.oral_glucose_tolerance, d.blood_pressure, d.skin_fold_thickness, d.serum_insulin, d.body_mass_index, d.pedigree_function, d.age, d.positive]
#
#       distances = @knn.nearest_neighbours(sample, k)
#
#       data_points = distances.collect {|d| d[2]}
#       positive = data_points.select {|d| d[8] == 1}.count
#       negative = data_points.select {|d| d[8] == 0}.count
#       decision = positive >= negative ? 1 : 0
#
#       actual == decision ? correctly_classified +=1 : incorrectly_classified +=1
#
#       results << {decision: decision, actual: actual, sample: sample, distances: distances}
#     end
#
#     accuracy = ((correctly_classified.to_f/@test_data_set.count)*100).round(2)
#     inaccuracy = ((incorrectly_classified.to_f/@test_data_set.count)*100).round(2)
#
#     {training_instances: training_instances,
#      test_instances: test_instances,
#      correctly_classified: correctly_classified,
#      incorrectly_classified: incorrectly_classified,
#      accuracy: accuracy,
#      inaccuracy: inaccuracy,
#      data: results}
#   end
#
# end