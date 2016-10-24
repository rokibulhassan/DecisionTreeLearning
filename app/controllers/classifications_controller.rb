class ClassificationsController < ApplicationController

  def predict
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

    @predicted_positive = @predictions.select { |p| p[:decision] == 1 }.count
    @predicted_negative = @predictions.select { |p| p[:decision] == 0 }.count

    @percent_positive = calculate_accuracy(@actual_positive, @predicted_positive)
    @percent_negative = calculate_accuracy(@actual_negative, @predicted_negative)
  end

  def knowledge_base
    @predictions = Classification.new.knowledge_base

    @actual_positive = @predictions.select { |p| p[:sample][8] == 1 }.count
    @actual_negative = @predictions.select { |p| p[:sample][8] == 0 }.count

    @predicted_positive = @predictions.select { |p| p[:decision] == 1 }.count
    @predicted_negative = @predictions.select { |p| p[:decision] == 0 }.count

    @percent_positive = calculate_accuracy(@actual_positive, @predicted_positive)
    @percent_negative = calculate_accuracy(@actual_negative, @predicted_negative)
  end

  def knn_numerical
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

    @predictions.each do |prediction|
      prediction[:actual] == prediction[:decision] ? @predicted_positive +=1 : @predicted_negative +=1
    end

    @percent_positive = calculate_accuracy(@actual_positive, @predicted_positive)
    @percent_negative = calculate_accuracy(@actual_negative, @predicted_negative)
  end

  def id3_tree
    pdf_filename = File.join(Rails.root, "public/id3_tree.pdf")
    send_file(pdf_filename, :filename => "id3_tree.pdf", :disposition => 'inline', :type => "application/pdf")
  end

  def sample
    @diabetic = Diabetic.new
  end
end
