class Fabrication::Schematic::Attribute

  attr_accessor :name, :params, :value

  def initialize(name, params, value=nil)
    self.name = name
    self.params = params
    self.value = value
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
