ORDINALS = {
  "first" => 0,
  "second" => 1
}

def dehumanize(string)
  string.gsub(/\W+/,'_').downcase
end

def generate_fabricator_name(model_name)
  model_name.singularize.to_sym
end

def get_class(model_name)
  fabricator_name = generate_fabricator_name(model_name)
  Fabrication.manager[fabricator_name].send(:klass)
end


Then /^that ([^"]*) should be persisted$/ do |object_name|
  object_name = dehumanize(object_name)
  object = fabrications[object_name]
  object.should be_persisted
end

Then /^that ([^"]*) should have "([^"]*)" for a "([^"]*)"$/ do |object_name, value, field|
  object_name = dehumanize(object_name)
  object = fabrications[object_name]
  object.send(dehumanize(field)).to_s.should == value
end

Then /^they should be persisted$/ do
  @they.each do |object|
    object.should be_persisted
  end
end

Then /^they should reference that ([^"]*)$/ do |parent_name|
  parent_name = dehumanize(parent_name)
  parent = fabrications[parent_name]
  parent_class = get_class(parent_name)
  parent_class_name = parent_class.to_s.underscore

  @they.each do |object|
    object.send(parent_class_name).should == parent
  end
end

Then /^the ([^"]*) should have "([^"]*)" for a "([^"]*)"$/ do |ordindal, value, field|
  object = @they[ORDINALS[ordindal]]
  object.send(dehumanize(field)).to_s.should == value
end

Then /^that ([^"]*) should reference that ([^"]*)$/ do |child_name, parent_name|
  parent_name = dehumanize(parent_name)
  parent = fabrications[parent_name]
  parent_class = get_class(parent_name)
  parent_class_name = parent_class.to_s.underscore
  child_name = dehumanize(child_name)
  child = fabrications[child_name]
  child.send(parent_class_name).should == parent
end

Then /^that (.*) should have (\d+) (.*)$/ do |parent_name, count, child_name|
  parent_name = dehumanize(parent_name)
  parent = fabrications[parent_name]
  parent.send(dehumanize(child_name).pluralize).count.should == count.to_i
end
