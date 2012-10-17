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

  def processed_value(processed_attributes)
    if count
      (1..count).map { |i| value.call(processed_attributes, i) }
    elsif value_proc?
      value.call(processed_attributes)
    else
      value
    end
  end

  private

  def count; params[:count] end
  def value_proc?; Proc === value end

end
