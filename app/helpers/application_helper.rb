module ApplicationHelper
  def calculate_accuracy(actual, prediction)
    result = actual > prediction ? (prediction.to_f/actual)*100 : (actual.to_f/prediction)*100
    result.round(2)
  end
end
