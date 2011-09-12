require 'fabrication/cucumber'

World(FabricationMethods)

Given /^(\d+) ([^"]*)$/ do |count, model_name|
  @they = Fabrication::Cucumber::StepFabricator.new(model_name).n(count.to_i)
end

Given /^the following ([^"]*):$/ do |model_name, table|
  @they = Fabrication::Cucumber::StepFabricator.new(model_name).from_table(table)
end

Given /^that ([^"]*) has the following ([^"]*):$/ do |parent, child, table|
  @they = Fabrication::Cucumber::StepFabricator.new(child, :parent => parent).from_table(table)
end

Given /^that ([^"]*) has (\d+) ([^"]*)$/ do |parent, count, child|
  @they = Fabrication::Cucumber::StepFabricator.new(child, :parent => parent).n(count.to_i)
end

Given /^(?:that|those) (.*) belongs? to that (.*)$/ do |children, parent|
  Fabrication::Cucumber::StepFabricator.new(parent).has_many(children)
end

Then /^I should see (\d+) ([^"]*) in the database$/ do |count, model_name|
  Fabrication::Cucumber::StepFabricator.new(model_name).klass.count.should == count.to_i
end

Then /^I should see the following (.*) in the database:$/ do |model_name, table|
  klass = Fabrication::Cucumber::StepFabricator.new(model_name).klass
  klass.where(table.rows_hash).count.should == 1
end
