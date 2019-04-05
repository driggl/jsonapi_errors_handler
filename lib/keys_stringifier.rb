class KeysStringifier
  def self.call(hash)
    hash.reduce({}) do |h, (k,v)|
      new_val = v.is_a?(Hash) ? self.call(v) : v
      h.merge({k.to_s => new_val})
    end
  end
end
