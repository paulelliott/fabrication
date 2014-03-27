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
    if process_count
      (1..process_count).map { |i| execute(processed_attributes, i, &value) }
    elsif value_proc?
      execute(processed_attributes, &value)
    else
      value
    end
  end

  def value_static?; !value_proc? end
  def value_proc?; Proc === value end

  private

  def execute(*args, &block)
    Fabrication::Schematic::Runner.new(klass).instance_exec(*args, &block)
  end

  def process_count
    count || rand
  end

  def count
    params[:count]
  end

  def rand
    Kernel.rand((1..params[:rand])) if params[:rand]
  end

end
