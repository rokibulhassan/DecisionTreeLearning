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

    @predictions = sample.present? ? Classification.new.predict(sample) : Classification.new.knowledge_base
  end

  def knowledge_base
    @predictions = Classification.new.knowledge_base
  end

  def id3_tree
    pdf_filename = File.join(Rails.root, "public/id3_tree.pdf")
    send_file(pdf_filename, :filename => "id3_tree.pdf", :disposition => 'inline', :type => "application/pdf")
  end

  def sample
    @diabetic = Diabetic.new
  end
end
