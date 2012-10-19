class Fabrication::Schematic::Attribute

  attr_accessor :klass, :name, :params, :value

  def initialize(klass, name, value, params={}, &block)
    self.klass = klass
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
      (1..count).map { |i| execute(processed_attributes, i, &value) }
    elsif value_proc?
      execute(processed_attributes, &value)
    else
      value
    end
  end

  private

  def execute(*args, &block)
    Fabrication::Schematic::Runner.new(klass).instance_exec(*args, &block)
  end

  def count; params[:count] end
  def value_proc?; Proc === value end

end
