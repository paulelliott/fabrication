ORDINALS = {
  "first" => 0,
  "second" => 1
}

Then /^that ([^"]*) should be persisted$/ do |object_name|
  object = instance_variable_get("@#{object_name}")
  object.should be_persisted
end

Then /^that ([^"]*) should have "([^"]*)" for a "([^"]*)"$/ do |object_name, value, field|
  object = instance_variable_get("@#{object_name}")
  object.send(field).should == value
end

Then /^they should be persisted$/ do
  @they.each do |object|
    object.should be_persisted
  end
end

Then /^they should reference that ([^"]*)$/ do |parent_name|
  parent = instance_variable_get("@#{parent_name}")
  parent_class = get_class(parent_name)
  parent_class_name = parent_class.to_s.downcase

  @they.each do |object|
    object.send(parent_class_name).should == parent
  end
end

Then /^the ([^"]*) should have "([^"]*)" for a "([^"]*)"$/ do |ordindal, value, field|
  object = @they[ORDINALS[ordindal]]
  object.send(field).should == value
end

Then /^that ([^"]*) should reference that ([^"]*)$/ do |child_name, parent_name|
  parent = instance_variable_get("@#{parent_name}")
  parent_class = get_class(parent_name)
  parent_class_name = parent_class.to_s.downcase
  child = instance_variable_get("@#{child_name}")
  child.send(parent_class_name).should == parent
end

Then /^there should be (\d+) ([^"]*)$/ do |count, class_name|
  Fabrication::Support.class_for(class_name.singularize).count.should == count.to_i
end
