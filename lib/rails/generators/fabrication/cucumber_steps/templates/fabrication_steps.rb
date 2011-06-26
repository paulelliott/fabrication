module FabricationMethods

  def create_from_table(model_name, table, extra = {})
    model_name = dehumanize(model_name)
    fabricator_name = generate_fabricator_name(model_name)
    is_singular = model_name.to_s.singularize == model_name.to_s
    hashes = is_singular ? [table.rows_hash] : table.hashes
    @they = hashes.map do |hash|
      hash = parameterize_hash(hash.merge(extra))
      Fabricate(fabricator_name, hash)
    end
    instantize(fabricator_name, is_singular)
  end

  def create_with_default_attributes(model_name, count, extra = {})
    fabricator_name = generate_fabricator_name(dehumanize(model_name))
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

  def parameterize_hash(hash)
    hash.inject({}) {|h,(k,v)| h.update(dehumanize(k).to_sym => v)}
  end

  def parentship(parent, child)
    parent_instance = instance_variable_get("@#{dehumanize(parent)}")
    parent_class_name = parent_instance.class.to_s.underscore
    child_class = get_class(dehumanize(child))

    if child_class && !child_class.new.respond_to?("#{parent_class_name}=")
      parent_class_name = parent_class_name.pluralize
      parent_instance = [parent_instance]
    end

    { parent_class_name => parent_instance }
  end

  def class_from_model_name(model_name)
    eval(dehumanize(model_name).singularize.classify)
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
  child_or_children = dehumanize(child_or_children)

  child_or_children_instance = instance_variable_get("@#{child_or_children}")
  [child_or_children_instance].flatten.each do |child_instance|
    child_instance.send("#{parent}=", parent_instance)
    child_instance.save
  end
end

Then /^I should see (\d+) ([^"]*) in the database$/ do |count, model_name|
  get_class(dehumanize(model_name)).count.should == count.to_i
end

Then /^I should see the following (.*) in the database:$/ do |model_name, table|
  get_class(dehumanize(model_name)).where(table.rows_hash).count.should == 1
end
