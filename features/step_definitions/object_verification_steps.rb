Then /^that ([^"]*) should be persisted$/ do |object_name|
  object = instance_variable_get("@#{object_name}")
  object.should be_persisted
end

Then /^that ([^"]*) should have "([^"]*)" for a "([^"]*)"$/ do |object_name, value, field|
  object = instance_variable_get("@#{object_name}")
  object.send(field).should == value
end
