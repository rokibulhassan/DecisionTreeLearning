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

  def initialize(limit, offset, kernel_type='RBF', features=nil)
    @features = features||Diabetic::FEATURES

    @test_data_set = Diabetic.limit(limit).offset(offset)
    @training_data_set = Diabetic.excludes(@test_data_set.collect(&:id))

    @training = @training_data_set.collect {|d| @features.collect {|f| d.send(f)}}

    @problem = Libsvm::Problem.new
    @parameter = Libsvm::SvmParameter.new
    @parameter.kernel_type = "Libsvm::KernelType::#{kernel_type}".constantize
    @parameter.svm_type = Libsvm::SvmType::NU_SVC unless ['PRECOMPUTED'].include?(kernel_type)
    @parameter.cache_size = 200 # in megabytes
    @parameter.eps = 0.001
    @parameter.c = 100
    @parameter.nu = 0.0001

    @parameter.degree = 1 if ['POLY'].include?(kernel_type)
    @parameter.coef0 = 0.1 if ['SIGMOID', 'POLY'].include?(kernel_type)
    @parameter.gamma = 0.1 if ['RBF', 'SIGMOID', 'POLY'].include?(kernel_type)

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
      sample = @features.collect {|f| d.send(f)}
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
