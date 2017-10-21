module ApplicationHelper
  def calculate_accuracy(actual, prediction)
    result = actual > prediction ? (prediction.to_f/actual)*100 : (actual.to_f/prediction)*100
    result.round(2)
  end

  def get_accuracy(actual, total)
    result = (actual.to_f/total)*100
    result.round(2)
  end

  def predict_class(original, prediction)
    return 'TN' if original == 0 && prediction == 0
    return 'FP' if original == 0 && prediction == 1
    return 'TP' if original == 1 && prediction == 1
    return 'FN' if original == 1 && prediction == 0
  end

  def confusion_matrix(data_samples, svm=false)
    true_positive = 0
    true_negative = 0
    false_positive = 0
    false_negative = 0

    data_samples.each do |sample|
      diabetic = sample[:sample]
      prediction_class = predict_class(svm ? sample[:actual] : diabetic[8], sample[:decision])
      true_positive += 1 if prediction_class == 'TP'
      true_negative += 1 if prediction_class == 'TN'
      false_positive += 1 if prediction_class == 'FP'
      false_negative += 1 if prediction_class == 'FN'
    end

    accuracy = (true_positive + true_negative).to_f/(true_positive + true_negative + false_positive + false_negative)
    sensitivity = true_positive.to_f/(true_positive + false_negative)
    speciality = true_negative.to_f/(true_negative + false_positive)
    precision = true_positive.to_f/(true_positive + false_positive)

    {tp: true_positive,
     tn: true_negative,
     fp: false_positive,
     fn: false_negative,
     accuracy: accuracy.round(4),
     sensitivity: sensitivity.round(4),
     speciality: speciality.round(4),
     precision: precision.round(4)}
  end

  def average_accuracy(predictions)
    samples = predictions.collect {|p| p[:accuracy]}
    samples.mean.round(2)
  end

  def standard_deviation(predictions)
    samples = predictions.collect {|p| p[:accuracy]}
    samples.standard_deviation.round(2)
  end
end
