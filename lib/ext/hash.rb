class Hash
  def stringify_keys
    transform_keys {|key| key.to_s}
  end

  def transform_keys
    result = {}
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end

  # pattern: {"stm_title" => %w(title titles), "stm_label" => "label"}
  def map_keys(pattern)
    inv_pattern = pattern.inverse
    self.keys.each do |key|
      self[inv_pattern[key]] = self[key] if inv_pattern[key]
    end
    self
  end

  def inverse
    result = {}
    each do |key, val|
      Array(val).each do |subval|
        result[subval] = key
      end
    end
    result
  end

  def without_blanks
    self.select {|_key, val| !(val.nil? || val == "")}
  end

  def only(*keys)
    self.select {|key, _val| keys.include?(key)}
  end

  def exclude(*keys)
    self.select {|key, _val| ! keys.include?(key)}
  end
end
