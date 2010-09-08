class Fabrication::Attribute

  attr_accessor :name, :params, :value

  def initialize(name, params, value)
    self.name = name
    self.params = params
    self.value = value
  end

  def update!(attrs)
    self.params = attrs[:params] if attrs.has_key?(:params)
    self.value = attrs[:value] if attrs.has_key?(:value)
  end

end
