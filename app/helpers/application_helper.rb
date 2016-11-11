module ApplicationHelper
  def calculate_accuracy(actual, prediction)
    result = actual > prediction ? (prediction.to_f/actual)*100 : (actual.to_f/prediction)*100
    result.round(2)
    end

  def get_accuracy(actual, total)
    result = (actual.to_f/total)*100
    result.round(2)
  end
end
