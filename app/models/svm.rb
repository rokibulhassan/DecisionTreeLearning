class Svm
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

  def initialize(kernel_type='RBF')
    @training = Diabetic.pick(460).collect { |d| [d.pregnant,
                                                  d.oral_glucose_tolerance,
                                                  d.blood_pressure,
                                                  d.skin_fold_thickness,
                                                  d.serum_insulin,
                                                  d.body_mass_index,
                                                  d.pedigree_function,
                                                  d.age,
                                                  d.positive] }


    @problem = Libsvm::Problem.new
    @parameter = Libsvm::SvmParameter.new
    @parameter.kernel_type = "Libsvm::KernelType::#{kernel_type}".constantize
    @parameter.cache_size = 100 # in megabytes
    @parameter.eps = 0.001
    @parameter.c = 10


    @labels = @training.collect { |t| t.pop }
    @examples = @training.map { |ary| Libsvm::Node.features(ary) }


    @problem.set_examples(@labels, @examples)

    @svm = Libsvm::Model.train(@problem, @parameter)
  end

  def predict(sample=nil)
    actual = sample.pop
    decision = @svm.predict(Libsvm::Node.features(sample))
    return [{:sample => sample, :decision => decision.to_i, :actual => actual}]
  end

  def random
    results = []
    Diabetic.pick(230).each do |d|
      results << predict([d.pregnant, d.oral_glucose_tolerance, d.blood_pressure, d.skin_fold_thickness, d.serum_insulin, d.body_mass_index, d.pedigree_function, d.age, d.positive])
    end
    results.flatten!
  end

end