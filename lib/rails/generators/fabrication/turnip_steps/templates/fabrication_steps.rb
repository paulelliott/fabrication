placeholder :fabrication_count do
  match /\d+/ do |count|
    count.to_i
  end
  match /a/ do
    1
  end
  match /no/ do
    0
  end
end

placeholder :fabrication_model_name do
  match /([^"]*)/ do |model_name|
    model_name.to_s
  end
end

steps_for :global do
  def with_ivars(fabricator)
    @they = yield fabricator
    instance_variable_set("@#{fabricator.model}", @they)
  end
  
  step ':fabrication_count :fabrication_model_name' do |count, model_name|
    with_ivars Fabrication::Cucumber::StepFabricator.new(model_name) do |fab|
      fab.n(count)
    end
  end

  step 'the following :fabrication_model_name:' do |model_name, table|
    with_ivars Fabrication::Cucumber::StepFabricator.new(model_name) do |fab|
      fab.from_table(table)
    end
  end

  step 'that :fabrication_model_name has the following :fabrication_model_name:' do |parent, child, table|
    with_ivars Fabrication::Cucumber::StepFabricator.new(child, :parent => parent) do |fab|
      fab.from_table(table)
    end
  end

  step 'that :fabrication_model_name has :fabrication_count :fabrication_model_name' do |parent, count, child|
    with_ivars Fabrication::Cucumber::StepFabricator.new(child, :parent => parent) do |fab|
      fab.n(count)
    end
  end

  step 'that/those :fabrication_model_name belong/belongs to that :fabrication_model_name' do |children, parent|
    with_ivars Fabrication::Cucumber::StepFabricator.new(parent) do |fab|
      fab.has_many(children)
    end
  end

  step 'I should see :fabrication_count :fabrication_model_name in the database' do |count, model_name|
    Fabrication::Cucumber::StepFabricator.new(model_name).klass.count.should == count
  end

  step 'I should see the following :fabrication_model_name in the database:' do |model_name, table|
    klass = Fabrication::Cucumber::StepFabricator.new(model_name).klass
    klass.where(table.hashes[0]).count.should == 1
  end
end