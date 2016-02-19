class Simple
  def initialize(attributes=nil, training=nil)
    @attributes = attributes || ['Temperature']
    @training = training ||[
        [36.6, 'healthy'],
        [37, 'sick'],
        [38, 'sick'],
        [36.7, 'healthy'],
        [40, 'sick'],
        [50, 'really sick']
    ]
  end

  def tree
    dec_tree = DecisionTree::ID3Tree.new(@attributes, @training, 'sick', :continuous)
    dec_tree.train
    rule_set = dec_tree.rule_set

    result = rule_set.rules.each { |r| r.accuracy(rule_set.train_data) }
    result.collect { |r| ap [r.conclusion, r.accuracy] }
  end
end