class Fabrication::Schematic::Attribute

  attr_accessor :klass, :name, :value
  attr_writer :params

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
    count || rand || rand_range
  end

  def count
    params[:count]
  end

  def rand
    return unless params[:rand]

    range = params[:rand]
    range = 1..range unless range.is_a? Range

    Kernel.rand(range)
  end

  def rand_range
    Kernel.rand((params[:start_range]..params[:end_range])) if params[:start_range] && params[:end_range]
  end

end
