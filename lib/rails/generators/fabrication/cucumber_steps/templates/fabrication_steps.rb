module FabricationMethods

  def create_from_table(model_name, table, extra = {})
    model_name = dehumanize(model_name)
    fabricator_name = generate_fabricator_name(model_name)
    is_singular = model_name.to_s.singularize == model_name.to_s
    hashes = is_singular ? [table.rows_hash] : table.hashes
    @they = hashes.map do |hash|
      hash = hash.merge(extra).inject({}) {|h,(k,v)| h.update(k.gsub(/\W+/,'_').to_sym => v)}
      Fabricate(fabricator_name, hash)
    end
    instantize(fabricator_name, is_singular)
  end

  def create_with_default_attributes(model_name, count, extra = {})
    model_name = dehumanize(model_name)
    fabricator_name = generate_fabricator_name(model_name)
    is_singular = count == 1
    @they = count.times.map { Fabricate(fabricator_name, extra) }
    instantize(fabricator_name, is_singular)
  end

  def dehumanize(string)
    string.gsub(/\W+/,'_').downcase
  end

  def generate_fabricator_name(model_name)
    model_name.singularize.to_sym
  end

  def get_class(model_name)
    fabricator_name = generate_fabricator_name(model_name)
    Fabrication::Fabricator.schematics[fabricator_name].klass
  end

  def instantize(fabricator_name, is_singular)
    if is_singular
      @it = @they.last
      instance_variable_set("@#{fabricator_name}", @it)
    else
      instance_variable_set("@#{fabricator_name.to_s.pluralize}", @they)
    end
  end

  def parentship(parent, child)
    parent = dehumanize(parent)
    parent_instance = instance_variable_get("@#{parent}")
    parent_class = get_class(parent)
    parent_class_name = parent_class.to_s.downcase

    child = dehumanize(child)
    child_class = get_class(child)

    if child_class && !child_class.new.respond_to?("#{parent_class_name}=")
      parent_class_name = parent_class_name.pluralize
      parent_instance = [parent_instance]
    end

    { parent_class_name => parent_instance }
  end

end

World(FabricationMethods)

Given /^(\d+) ([^"]*)$/ do |count, model_name|
  create_with_default_attributes(model_name, count.to_i)
end

Given /^the following ([^"]*):$/ do |model_name, table|
  create_from_table(model_name, table)
end

Given /^that ([^"]*) has the following ([^"]*):$/ do |parent, child, table|
  create_from_table(child, table, parentship(parent, child))
end

Given /^that ([^"]*) has (\d+) ([^"]*)$/ do |parent, count, child|
  create_with_default_attributes(child, count.to_i, parentship(parent, child))
end

Given /^(?:that|those) (.*) belongs? to that (.*)$/ do |child_or_children, parent|
  parent = dehumanize(parent)
  parent_instance = instance_variable_get("@#{parent}")
  parent_class = get_class(parent)
  parent_class_name = parent_class.to_s.downcase
  child_or_children = dehumanize(child_or_children)

  child_or_children_instance = instance_variable_get("@#{child_or_children}")
  [child_or_children_instance].flatten.each do |child_instance|
    child_instance.send("#{parent_class_name}=", parent_instance)
    child_instance.save
  end
end
