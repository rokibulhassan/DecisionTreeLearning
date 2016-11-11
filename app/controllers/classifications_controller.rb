class ClassificationsController < ApplicationController

  def predict
    @chart_data = []
    @chart_data2 = []
    diabetic = params[:diabetic]
    sample = [diabetic[:pregnant].to_f,
              diabetic[:oral_glucose_tolerance].to_f,
              diabetic[:blood_pressure].to_f,
              diabetic[:skin_fold_thickness].to_f,
              diabetic[:serum_insulin].to_f,
              diabetic[:body_mass_index].to_f,
              diabetic[:pedigree_function].to_f,
              diabetic[:age].to_f,
              diabetic[:positive].to_i] if diabetic.present?

    @predictions = sample.present? ? Classification.new.predict(sample) : Classification.new.random

    @actual_positive = @predictions.select { |p| p[:sample][8] == 1 }.count
    @actual_negative = @predictions.select { |p| p[:sample][8] == 0 }.count

    @predicted_positive = 0
    @predicted_negative = 0
    @correctly_classified = 0
    @incorrectly_classified = 0

    @predictions.each do |prediction|
      sample = prediction[:sample]
      prediction[:actual] == prediction[:decision] ? @predicted_positive +=1 : @predicted_negative +=1
      if prediction[:actual] == prediction[:decision]
        @correctly_classified += 1
      else
        @incorrectly_classified += 1
      end
      @chart_data << {name: sample, data: {pregnant: sample[0],
                                           oral_glucose_tolerance: sample[1],
                                           blood_pressure: sample[2],
                                           skin_fold_thickness: sample[3],
                                           serum_insulin: sample[4],
                                           body_mass_index: sample[5],
                                           pedigree_function: sample[6],
                                           age: sample[7],
                                           actual: 900*prediction[:actual]}}

      @chart_data2 << {name: sample, data: {pregnant: sample[0],
                                            oral_glucose_tolerance: sample[1],
                                            blood_pressure: sample[2],
                                            skin_fold_thickness: sample[3],
                                            serum_insulin: sample[4],
                                            body_mass_index: sample[5],
                                            pedigree_function: sample[6],
                                            age: sample[7],
                                            decision: 900*prediction[:decision]}}

    end

    @accuracy = get_accuracy(@correctly_classified, @predictions.count)
    @inaccuracy = get_accuracy(@incorrectly_classified, @predictions.count)
    @pie_chart = [['correctly classified', @accuracy], ['incorrectly classified', @inaccuracy]]
  end


  def knn_numerical
    @chart_data = []
    @chart_data2 = []
    diabetic = params[:diabetic]
    radius = diabetic[:radios].to_i if diabetic.present?

    sample = [diabetic[:pregnant].to_f,
              diabetic[:oral_glucose_tolerance].to_f,
              diabetic[:blood_pressure].to_f,
              diabetic[:skin_fold_thickness].to_f,
              diabetic[:serum_insulin].to_f,
              diabetic[:body_mass_index].to_f,
              diabetic[:pedigree_function].to_f,
              diabetic[:age].to_f,
              diabetic[:positive].to_i] if diabetic.present?

    @predictions = sample.present? ? KnnNumerical.new.predict(sample, radius) : KnnNumerical.new.random

    @actual_positive = @predictions.select { |p| p[:actual] == 1 }.count
    @actual_negative = @predictions.select { |p| p[:actual] == 0 }.count

    @predicted_positive = 0
    @predicted_negative = 0
    @correctly_classified = 0
    @incorrectly_classified = 0

    @predictions.each do |prediction|
      sample = prediction[:sample]
      prediction[:actual] == prediction[:decision] ? @predicted_positive +=1 : @predicted_negative +=1
      if prediction[:actual] == prediction[:decision]
        @correctly_classified += 1
      else
        @incorrectly_classified += 1
      end
      @chart_data << {name: sample, data: {pregnant: sample[0],
                                           oral_glucose_tolerance: sample[1],
                                           blood_pressure: sample[2],
                                           skin_fold_thickness: sample[3],
                                           serum_insulin: sample[4],
                                           body_mass_index: sample[5],
                                           pedigree_function: sample[6],
                                           age: sample[7],
                                           actual: 900*prediction[:actual]}}

      @chart_data2 << {name: sample, data: {pregnant: sample[0],
                                            oral_glucose_tolerance: sample[1],
                                            blood_pressure: sample[2],
                                            skin_fold_thickness: sample[3],
                                            serum_insulin: sample[4],
                                            body_mass_index: sample[5],
                                            pedigree_function: sample[6],
                                            age: sample[7],
                                            decision: 900*prediction[:decision]}}

    end

    @accuracy = get_accuracy(@correctly_classified, @predictions.count)
    @inaccuracy = get_accuracy(@incorrectly_classified, @predictions.count)
    @pie_chart = [['correctly classified', @accuracy], ['incorrectly classified', @inaccuracy]]
  end

  def id3_tree
    pdf_filename = File.join(Rails.root, "public/id3_tree.pdf")
    send_file(pdf_filename, :filename => "id3_tree.pdf", :disposition => 'inline', :type => "application/pdf")
  end

  def sample
    @diabetic = Diabetic.new
  end
end
