class Fabrication::Schematic::Attribute

  attr_accessor :name, :params, :value

  def initialize(name, value, params={}, &block)
    self.name = name
    self.params = params
    self.value = value.nil? ? block : value
  end

  def params
    @params ||= {}
  end

  def transient!
    params[:transient] = true
  end

  def transient?
    params[:transient]
  end

end
