Keymaker.configure do |c|
  c.server = 'localhost'
end

class ParentKeymakerNode
  include Keymaker::Node
  property :before_save_value
  property :dynamic_field
  property :nil_field
  property :number_field
  property :string_field
  property :false_field

  attr_protected :number_field

  before_save do
    self.before_save_value = 11
  end
end
